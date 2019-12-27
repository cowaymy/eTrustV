package com.coway.trust.api.mobile.Img;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.cmmn.exception.FileDownException;
import com.coway.trust.util.EgovBasicLogger;
import com.coway.trust.util.EgovFormBasedFileUtil;
import com.coway.trust.util.EgovResourceCloseHelper;
/**
 * @ClassName : ImgFileDownloadController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 18.   KR-MIN       First creation
 * </pre>
 */
@Controller
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/imgFileDownloadApi")
public class ImgFileDownloadController {

    private static final Logger logger = LoggerFactory.getLogger(ImgFileDownloadController.class);

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@Value("${web.resource.upload.file}")
	private String uploadDirWeb;

	@Autowired
	private FileService fileService;

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
	@RequestMapping(value = "/fileDownWeb.do")
	public void fileDownWeb(@RequestParam Map<String, Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
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

		if( logger.isDebugEnabled() ){
		    logger.debug(":::::::::::::::::::::::::::::::::::::::::::::::::::::");
		    logger.debug("uploadDirWeb : " + uploadDirWeb);
		    logger.debug("File.separator : "+ File.separator);
		    logger.debug("subPath : " + subPath);
            logger.debug("fileName : " + fileName);
		    logger.debug(":::::::::::::::::::::::::::::::::::::::::::::::::::::");
		}
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
     * 이미지 view를 제공한다.
     *
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/editor/imageSrc.do", method = RequestMethod.GET)
    public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String subPath = request.getParameter("path");
        String physical = request.getParameter("physical");
        String mimeType = request.getParameter("contentType");
        EgovFormBasedFileUtil.viewFile(response, uploadDirWeb, subPath, physical, mimeType);
    }
}
