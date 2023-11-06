package com.coway.trust.web.file;

import java.io.*;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.FileDownException;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.AWSS3Service;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.util.EgovBasicLogger;
import com.coway.trust.util.EgovResourceCloseHelper;

/**
 * 파일 다운로드를 위한 컨트롤러 클래스
 *
 * @author 공통서비스개발팀 이삼섭
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 *      <pre>
 * << 개정이력(Modification Information) >>
 *
 *     수정일      	수정자           수정내용
 *  ------------   --------    ---------------------------
 *   2009.03.25  	이삼섭          최초 생성
 *   2014.02.24		이기하          IE11 브라우저 한글 파일 다운로드시 에러 수정
 *
 * Copyright (C) 2009 by MOPAS  All right reserved.
 *      </pre>
 */
@Controller
@RequestMapping(value = "/file")
public class EgovFileDownloadController {

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@Value("${web.resource.upload.file}")
	private String uploadDirWeb;

    @Value("${com.file.mobile.upload.path}")
    private String fileDownWasMobile;

	@Autowired
	private FileService fileService;

	@Autowired
  private AWSS3Service awsservice;

	/**
	 * 브라우저 구분 얻기.
	 *
	 * @param request
	 * @return
	 */
	private String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.contains("MSIE")) {
			return "MSIE";
		} else if (header.contains("Trident")) { // IE11 문자열 깨짐 방지
			return "Trident";
		} else if (header.contains("Chrome")) {
			return "Chrome";
		} else if (header.contains("Opera")) {
			return "Opera";
		}
		return "Firefox";
	}

	/**
	 * Disposition 지정하기.
	 *
	 * @param filename
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String browser = getBrowser(request);

		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Trident")) { // IE11 문자열 깨짐 방지
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		} else {
			throw new IOException("Not supported browser");
		}

		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

		if ("Opera".equals(browser)) {
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
	}

	/**
	 * 첨부파일로 등록된 파일에 대하여 다운로드를 제공한다.
	 *
	 * @param params
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/fileDown.do")
	public void fileDownload(@RequestParam Map<String, Object> params, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String fileId = (String) params.get("fileId");
		String subPath;
		String fileName;
		String originalFileName;

		if (StringUtils.isNotEmpty(fileId)) {
			FileVO fileVO = fileService.getFile(Integer.parseInt(fileId));
			subPath = fileVO.getFileSubPath();
			fileName = fileVO.getPhysiclFileName();
			originalFileName = fileVO.getAtchFileName();
		} else {
			subPath = (String) params.get("subPath");
			fileName = (String) params.get("fileName");
			originalFileName = (String) params.get("orignlFileNm");
		}

		File uFile = new File(uploadDirWeb + File.separator + subPath, fileName);
		long fSize = uFile.length();

		if (fSize > 0) {
			String mimetype = "application/x-msdownload";
			response.setContentType(mimetype);
			response.setHeader("Set-Cookie", "fileDownload=true; path=/"); 	///resources/js/jquery.fileDownload.js   callback 호출시 필수.
			setDisposition(originalFileName, request, response);
			BufferedInputStream in = null;
			BufferedOutputStream out = null;

			try {
				in = new BufferedInputStream(new FileInputStream(uFile));
				out = new BufferedOutputStream(response.getOutputStream());

				FileCopyUtils.copy(in, out);
				out.flush();
			} catch (IOException ex) {
				EgovBasicLogger.ignore("IO Exception", ex);
			} finally {
				EgovResourceCloseHelper.close(in, out);
			}

		} else {

			throw new FileDownException(AppConstants.FAIL, "Could not get file name : " + originalFileName);
//			response.setContentType("application/x-msdownload");
//			response.setHeader("Set-Cookie", "fileDownload=true; path=/"); 	///resources/js/jquery.fileDownload.js   callback 호출시 필수.
//			PrintWriter printwriter = response.getWriter();
//
//			printwriter.println("<html>");
//			printwriter.println("<br><br><br><h2>Could not get file name:<br>" + originalFileName + "</h2>");
//			printwriter.println("<br><br><br><center><h3><a href='javascript: history.go(-1)'>Back</a></h3></center>");
//			printwriter.println("<br><br><br>&copy; webAccess");
//			printwriter.println("</html>");
//
//			printwriter.flush();
//			printwriter.close();
		}
	}

	/**
	 * 첨부파일로 등록된 파일에 대하여 다운로드를 제공한다.
	 *
	 * @param params
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/fileDownClaim.do")
	public void fileDownClaim(@RequestParam Map<String, Object> params, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String fileId = (String) params.get("fileId");
		String subPath;
		String fileName;
		String originalFileName;

		if (StringUtils.isNotEmpty(fileId)) {
			FileVO fileVO = fileService.getFile(Integer.parseInt(fileId));
			subPath = fileVO.getFileSubPath();
			fileName = fileVO.getPhysiclFileName();
			originalFileName = fileVO.getAtchFileName();
		} else {
			subPath = (String) params.get("subPath");
			fileName = (String) params.get("fileName");
			originalFileName = (String) params.get("orignlFileNm");
		}

		File uFile = new File(uploadDir + "/" + subPath, fileName);
		long fSize = uFile.length();

		if (fSize > 0) {

			String mimetype = "application/x-msdownload";
			response.setContentType(mimetype);
			response.setHeader("Set-Cookie", "fileDownload=true; path=/"); 	///resources/js/jquery.fileDownload.js   callback 호출시 필수.
			setDisposition(originalFileName, request, response);
			BufferedInputStream in = null;
			BufferedOutputStream out = null;

			try {
				in = new BufferedInputStream(new FileInputStream(uFile));
				out = new BufferedOutputStream(response.getOutputStream());

				FileCopyUtils.copy(in, out);
				out.flush();
			} catch (IOException ex) {
				EgovBasicLogger.ignore("IO Exception", ex);
			} finally {
				EgovResourceCloseHelper.close(in, out);
			}

		} else {

			throw new FileDownException(AppConstants.FAIL, "Could not get file name : " + originalFileName);
		}
	}

	/**
	 * 첨부파일로 등록된 파일에 대하여 다운로드를 제공한다.
	 *
	 * @param params
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/fileDownWeb.do")
	public void fileDownWeb(@RequestParam Map<String, Object> params, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		String fileId = (String) params.get("fileId");
		String subPath;
		String fileName;
		String originalFileName;

		if (StringUtils.isNotEmpty(fileId)) {
			FileVO fileVO = fileService.getFile(Integer.parseInt(fileId));
			subPath = fileVO.getFileSubPath();
			fileName = fileVO.getPhysiclFileName();
			originalFileName = fileVO.getAtchFileName();
		} else {
			subPath = (String) params.get("subPath");
			fileName = (String) params.get("fileName");
			originalFileName = (String) params.get("orignlFileNm");
		}

		File uFile = new File(uploadDirWeb + File.separator + subPath, fileName);
		long fSize = uFile.length();

		if (fSize > 0) {
			String mimetype = "application/x-msdownload";
			response.setContentType(mimetype);
			response.setHeader("Set-Cookie", "fileDownload=true; path=/"); 	///resources/js/jquery.fileDownload.js   callback 호출시 필수.
			setDisposition(originalFileName, request, response);
			BufferedInputStream in = null;
			BufferedOutputStream out = null;

			try {
				in = new BufferedInputStream(new FileInputStream(uFile));
				out = new BufferedOutputStream(response.getOutputStream());

				FileCopyUtils.copy(in, out);
				out.flush();
			} catch (IOException ex) {
				EgovBasicLogger.ignore("IO Exception", ex);
			} finally {
				EgovResourceCloseHelper.close(in, out);
			}

		} else {

			throw new FileDownException(AppConstants.FAIL, "Could not get file name : " + originalFileName);
		}
	}

    /**
     * 첨부파일로 등록된 파일에 대하여 다운로드를 제공한다.
     *
     * @param params
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/fileDownWasMobile.do")
    public void fileDownWasMobile(@RequestParam Map<String, Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String fileId = (String) params.get("fileId");
        String subPath;
        String fileName;
        String originalFileName;

        if (StringUtils.isNotEmpty(fileId)) {
            FileVO fileVO = fileService.getFile(Integer.parseInt(fileId));
            subPath = fileVO.getFileSubPath();
            fileName = fileVO.getPhysiclFileName();
            originalFileName = fileVO.getAtchFileName();
        } else {
            subPath = (String) params.get("subPath");
            fileName = (String) params.get("fileName");
            originalFileName = (String) params.get("orignlFileNm");
        }

        File uFile = new File(fileDownWasMobile + File.separator + subPath, fileName);
        long fSize = uFile.length();

        if (fSize > 0) {
            String mimetype = "application/x-msdownload";
            response.setContentType(mimetype);
            response.setHeader("Set-Cookie", "fileDownload=true; path=/");  ///resources/js/jquery.fileDownload.js   callback 호출시 필수.
            setDisposition(originalFileName, request, response);
            BufferedInputStream in = null;
            BufferedOutputStream out = null;

            try {
                in = new BufferedInputStream(new FileInputStream(uFile));
                out = new BufferedOutputStream(response.getOutputStream());

                FileCopyUtils.copy(in, out);
                out.flush();
            } catch (IOException ex) {
                EgovBasicLogger.ignore("IO Exception", ex);
            } finally {
                EgovResourceCloseHelper.close(in, out);
            }

        } else {

            throw new FileDownException(AppConstants.FAIL, "Could not get file name : " + originalFileName);
        }
    }

    @RequestMapping(value = "/fileDownWebAws.do")
    public void fileDownWebAws(@RequestParam Map<String, Object> params, HttpServletRequest request,
        HttpServletResponse response) throws Exception {

      String fileId = (String) params.get("fileId");
      String subPath = "";
      String fileName = "";
      String originalFileName = "";
      //AWS Stream
      S3ObjectInputStream s3ObjIs  = null;

      if (StringUtils.isNotEmpty(fileId)) {
        FileVO fileVO = fileService.getFile(Integer.parseInt(fileId));
        subPath = fileVO.getFileSubPath();
        fileName = fileVO.getPhysiclFileName();
        originalFileName = fileVO.getAtchFileName();
      } else {
        subPath = (String) params.get("subPath");
        fileName = (String) params.get("fileName");
        originalFileName = (String) params.get("orignlFileNm");
      }
      s3ObjIs = awsservice.downloadSingleFile(  subPath, fileName);
      //File uFile = new File(uploadDirWeb + File.separator + subPath, fileName);
      //File uFile = new File(uploadDirWeb + File.separator + subPath, fileName);
      ObjectMetadata metadata =  awsservice.objectMetaData(  subPath, fileName);

      //long fSize = uFile.length();
      long fSize          =  metadata.getContentLength();
      String contentsType =  metadata.getContentType();

      if (fSize > 0) {
        //String mimetype = "application/x-msdownload";
        //response.setContentType(mimetype);
        response.setContentType(contentsType);
        response.setHeader("Set-Cookie", "fileDownload=true; path=/");  ///resources/js/jquery.fileDownload.js   callback 호출시 필수.
        setDisposition(originalFileName, request, response);
        BufferedInputStream in = null;
        BufferedOutputStream out = null;

        try {
          //in = new BufferedInputStream(new FileInputStream(uFile));
          in = new BufferedInputStream(s3ObjIs);
          out = new BufferedOutputStream(response.getOutputStream());

          FileCopyUtils.copy(in, out);
          out.flush();
        } catch (IOException ex) {
          EgovBasicLogger.ignore("IO Exception", ex);
        } finally {
          EgovResourceCloseHelper.close(in, out);
          if(s3ObjIs!=null) {s3ObjIs.close();}
        }

      } else {

        throw new FileDownException(AppConstants.FAIL, "Could not get file name : " + originalFileName);
      }
    }
}
