package com.coway.trust.util;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @Class Name : EgovFormBasedFileUtil.java
 * @Description : Form-based File Upload 유틸리티
 * @Modification Information
 *
 *               수정일 수정자 수정내용 ------- -------- --------------------------- 2009.08.26 한성곤 최초 생성
 *
 * @author 공통컴포넌트 개발팀 한성곤
 * @since 2009.08.26
 * @version 1.0
 * @see
 */
public class EgovFormBasedFileUtil {

	/** Buffer size */
	public static final int BUFFER_SIZE = 8192;

	public static final String SEPERATOR = File.separator;

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovFormBasedFileUtil.class);

	/**
	 * 오늘 날짜 문자열 취득. ex) 20090101
	 *
	 * @return
	 */
	public static String getTodayString() {
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd", Locale.getDefault());

		return format.format(new Date());
	}

	/**
	 * 물리적 파일명 생성.
	 *
	 * @return
	 */
	public static String getPhysicalFileName() {
		return UUIDGenerator.get().toUpperCase();
	}

	/**
	 * 파일명 변환.
	 *
	 * @param filename
	 *            String
	 * @return
	 * @throws Exception
	 */
	protected static String convert(String filename) throws Exception {
		// return java.net.URLEncoder.encode(filename, "utf-8");
		return filename;
	}

	/**
	 * Stream으로부터 파일을 저장함.
	 *
	 * @param is
	 *            InputStream
	 * @param file
	 *            File
	 * @throws IOException
	 */
	public static long saveFile(InputStream is, File file) throws IOException {


		file.setReadable(true, false);
		file.setExecutable(true, false);
		file.setWritable(true, false);

		// 디렉토리 생성
		File parentFile = file.getParentFile();

		parentFile.setReadable(true, false);
		parentFile.setExecutable(true, false);
		parentFile.setWritable(true, false);

		if (!parentFile.exists()) {
			LOGGER.debug("make dir...");
			parentFile.mkdirs();
		}

		OutputStream os = null;
		long size = 0L;

		try {
			os = new FileOutputStream(file);

			int bytesRead = 0;
			byte[] buffer = new byte[BUFFER_SIZE];

			while ((bytesRead = is.read(buffer, 0, BUFFER_SIZE)) != -1) {
				size += bytesRead;
				os.write(buffer, 0, bytesRead);
			}
		} finally {
			EgovResourceCloseHelper.close(os);
		}

		return size;
	}

	/**
	 * 파일을 Upload 처리한다.
	 *
	 * @param request
	 * @param where
	 * @param maxFileSize
	 * @return
	 * @throws Exception
	 */
//	public static List<EgovFormBasedFileVo> uploadFiles(HttpServletRequest request, final String uploadPath,
//			final String subPath, long maxFileSize) throws Exception {
//		List<EgovFormBasedFileVo> list = new ArrayList<EgovFormBasedFileVo>();
//
//		// Check that we have a file upload request
//		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
//
//		if (isMultipart) {
//			// Create a new file upload handler
//			ServletFileUpload upload = new ServletFileUpload();
//			upload.setFileSizeMax(maxFileSize); // SizeLimitExceededException
//
//			// Parse the request
//			FileItemIterator iter = upload.getItemIterator(request);
//			while (iter.hasNext()) {
//				FileItemStream item = iter.next();
//				String name = item.getFieldName();
//				InputStream stream = item.openStream();
//				if (item.isFormField()) {
//					LOGGER.info("Form field '{}' with value '{}' detected.", name, Streams.asString(stream));
//				} else {
//					LOGGER.info("File field '{}' with file name '{}' detected.", name, item.getName());
//
//					if ("".equals(item.getName())) {
//						continue;
//					}
//
//					// Process the input stream
//					EgovFormBasedFileVo vo = new EgovFormBasedFileVo();
//
//					String tmp = item.getName();
//
//					if (tmp.lastIndexOf("\\") >= 0) {
//						tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
//					}
//
//					vo.setFileName(tmp);
//					vo.setContentType(item.getContentType());
//					vo.setServerPath(uploadPath);
//					vo.setServerSubPath(subPath);
//					vo.setPhysicalName(getPhysicalFileName());
//
//					if (tmp.lastIndexOf(".") >= 0) {
//						vo.setPhysicalName(vo.getPhysicalName() + tmp.substring(tmp.lastIndexOf(".")));
//					}
//
//					long size = saveFile(stream,
//							new File(EgovWebUtil.filePathBlackList(uploadPath) + SEPERATOR
//									+ EgovWebUtil.filePathBlackList(vo.getServerSubPath()) + SEPERATOR
//									+ vo.getPhysicalName()));
//
//					vo.setSize(size);
//
//					list.add(vo);
//				}
//			}
//		} else {
//			throw new IOException("form's 'enctype' attribute have to be 'multipart/form-data'");
//		}
//
//		return list;
//	}

	/**
	 * 파일을 Download 처리한다.
	 *
	 * @param response
	 * @param where
	 * @param serverSubPath
	 * @param physicalName
	 * @param original
	 * @throws Exception
	 */
	public static void downloadFile(HttpServletResponse response, String where, String serverSubPath,
			String physicalName, String original) throws Exception {
		String downFileName = where + SEPERATOR + serverSubPath + SEPERATOR + physicalName;

		File file = new File(EgovWebUtil.filePathBlackList(downFileName));

		if (!file.exists()) {
			throw new FileNotFoundException(downFileName);
		}

		if (!file.isFile()) {
			throw new FileNotFoundException(downFileName);
		}

		byte[] b = new byte[BUFFER_SIZE];

		String reOriginal = original.replaceAll("\r", "").replaceAll("\n", "");
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + convert(reOriginal) + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Expires", "0");

		BufferedInputStream fin = null;
		BufferedOutputStream outs = null;

		try {
			fin = new BufferedInputStream(new FileInputStream(file));
			outs = new BufferedOutputStream(response.getOutputStream());

			int read = 0;

			while ((read = fin.read(b)) != -1) {
				outs.write(b, 0, read);
			}
		} finally {
			EgovResourceCloseHelper.close(outs, fin);
		}
	}

	/**
	 * 이미지에 대한 미리보기 기능을 제공한다.
	 *
	 * mimeType의 경우는 JSP 상에서 다음과 같이 얻을 수 있다. getServletConfig().getServletContext().getMimeType(name);
	 *
	 * @param response
	 * @param where
	 * @param serverSubPath
	 * @param physicalName
	 * @param mimeTypeParam
	 * @throws Exception
	 */
	public static void viewFile(HttpServletResponse response, String where, String serverSubPath, String physicalName,
			String mimeTypeParam) throws Exception {
		String mimeType = mimeTypeParam;
		String downFileName = where + SEPERATOR + serverSubPath + SEPERATOR + physicalName;

		File file = new File(EgovWebUtil.filePathBlackList(downFileName));

		if (!file.exists()) {
			throw new FileNotFoundException(downFileName);
		}

		if (!file.isFile()) {
			throw new FileNotFoundException(downFileName);
		}

		byte[] b = new byte[BUFFER_SIZE];

		if (mimeType == null) {
			mimeType = "application/octet-stream;";
		}

		response.setContentType(EgovWebUtil.removeCRLF(mimeType));
		response.setHeader("Content-Disposition", "filename=image;");

		BufferedInputStream fin = null;
		BufferedOutputStream outs = null;

		try {
			fin = new BufferedInputStream(new FileInputStream(file));
			outs = new BufferedOutputStream(response.getOutputStream());

			int read = 0;

			while ((read = fin.read(b)) != -1) {
				outs.write(b, 0, read);
			}
		} finally {
			EgovResourceCloseHelper.close(outs, fin);
		}
	}

	public static File streamToFile (InputStream in, String fileName, String extension) throws IOException {
		final File tempFile = File.createTempFile(fileName + "_", "." + extension);
		tempFile.deleteOnExit();
		try (FileOutputStream out = new FileOutputStream(tempFile)) {
			IOUtils.copy(in, out);
		}
		return tempFile;
	}

	public static long saveImageFile(InputStream is, File file) throws IOException {

    file.setReadable(true, false);
    file.setExecutable(true, false);
    file.setWritable(true, false);

    // 디렉토리 생성
    File parentFile = file.getParentFile();

    parentFile.setReadable(true, false);
    parentFile.setExecutable(true, false);
    parentFile.setWritable(true, false);

    if (!parentFile.exists()) {
      parentFile.mkdirs();
    }

    OutputStream os = null;
    long size = 0L;

    try {
      os = new FileOutputStream(file);
      ImageWriter writer = null;
      ImageOutputStream ios = null;

      BufferedImage image = ImageIO.read(is);
      Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpg");
      writer = (ImageWriter) writers.next();
      ios = ImageIO.createImageOutputStream(os);
      writer.setOutput(ios);

      ImageWriteParam param = writer.getDefaultWriteParam();

      param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
      param.setCompressionQuality(0.7f); // Change the quality value you prefer
      writer.write(null, new IIOImage(image, null, null), param);

      size = ios.length();

      ios.close();
      writer.dispose();


    } finally {
      EgovResourceCloseHelper.close(os);
    }

    return size;
  }

}
