package com.coway.trust.cmmn.file;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.*;

/**
 * @Class Name : EgovFileUploadUtil.java
 * @Description : Spring 기반 File Upload 유틸리티
 * @Modification Information
 *
 *               수정일 수정자 수정내용 ------- -------- --------------------------- 2009.08.26 한성곤 최초 생성
 *
 * @author 공통컴포넌트 개발팀 한성곤
 * @since 2009.08.26
 * @version 1.0
 * @see
 */
public class EgovFileUploadUtil extends EgovFormBasedFileUtil {
	/**
	 * 파일을 Upload 처리한다.
	 *
	 * @param request
	 * @param uploadPath
	 * @param subPath
	 * @param maxFileSize
	 * @return
	 * @throws Exception
	 */
	public static List<EgovFormBasedFileVo> uploadFiles(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize) throws Exception {
		return uploadFiles(request, uploadPath, subPath, maxFileSize, false);
	}

	public static List<EgovFormBasedFileVo> uploadFiles3(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize) throws Exception {
		return uploadFiles3(request, uploadPath, subPath, maxFileSize, false);
	}

	/**
	 * 파일을 Upload 처리한다.
	 *
	 * @param request
	 * @param uploadPath
	 * @param subPath
	 * @param maxFileSize
	 * @param addExtension
	 *            : application-xxx.properties 의 web.resource.upload.file(resource 접근 가능 파일 경로) 를 참조한 경우 확장자가 있어야지만 바로 열
	 *            수 있다.
	 * @return
	 * @throws Exception
	 */
	public static List<EgovFormBasedFileVo> uploadFiles(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize, boolean addExtension) throws Exception {
		List<EgovFormBasedFileVo> list = new ArrayList<>();

		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
		Iterator<?> fileIter = mptRequest.getFileNames();

		while (fileIter.hasNext()) {
			MultipartFile mFile = mptRequest.getFile((String) fileIter.next());

			if (mFile.getSize() > maxFileSize) {
				throw new ApplicationException(AppConstants.FAIL,
						CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
								AppConstants.MSG_FILE_MAX_LIMT,
								new Object[] { CommonUtils.formatFileSize(maxFileSize) }));
			}

			EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

			String tmp = mFile.getOriginalFilename();

			if (tmp.lastIndexOf("\\") >= 0) {
				tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
			}

			String blackUploadPath = EgovWebUtil.filePathBlackList(uploadPath);
			String blackSubPath = EgovWebUtil.filePathBlackList(subPath);

			vo.setFileName(tmp);
			vo.setContentType(mFile.getContentType());
			vo.setServerPath(blackUploadPath);
			vo.setServerSubPath(blackSubPath);

			String physicalName = getPhysicalFileName();

			if (addExtension) {
				physicalName = physicalName + "." + FilenameUtils.getExtension(tmp).toLowerCase();
			}

			vo.setPhysicalName(physicalName);
			vo.setSize(mFile.getSize());
			vo.setExtension(FilenameUtils.getExtension(tmp).toLowerCase());

			if (mFile.getSize() > 0) {
				InputStream is = null;

				try {
					is = mFile.getInputStream();

					if (MimeTypeUtil.isNotAllowFile(is)) {
						throw new ApplicationException(AppConstants.FAIL,
								mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
					}

					saveFile(is, new File(EgovWebUtil.filePathBlackList(vo.getServerPath() + SEPERATOR
							+ vo.getServerSubPath() + SEPERATOR + vo.getPhysicalName())));
				} finally {
					if (is != null) {
						is.close();
					}
				}
				list.add(vo);
			}
		}

		return list;
	}

	/**
	 * 파일을 Upload 처리한다.
	 *
	 * @param request
	 * @param uploadPath
	 * @param subPath
	 * @param maxFileSize
	 * @param addExtension
	 *            : application-xxx.properties 의 web.resource.upload.file(resource 접근 가능 파일 경로) 를 참조한 경우 확장자가 있어야지만 바로 열
	 *            수 있다.
	 * @return
	 * @throws Exception
	 */
	public static List<EgovFormBasedFileVo> uploadFiles3(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize, boolean addExtension) throws Exception {
		List<EgovFormBasedFileVo> list = new ArrayList<>();

		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
		Iterator<?> fileIter = mptRequest.getFileNames();

		while (fileIter.hasNext()) {
			MultipartFile mFile = mptRequest.getFile((String) fileIter.next());

			if (mFile.getSize() > maxFileSize) {
				throw new ApplicationException(AppConstants.FAIL,
						CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
								AppConstants.MSG_FILE_MAX_LIMT,
								new Object[] { CommonUtils.formatFileSize(maxFileSize) }));
			}

			EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

			String tmp = mFile.getOriginalFilename();

			if (tmp.lastIndexOf("\\") >= 0) {
				tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
			}

			String blackUploadPath = EgovWebUtil.filePathBlackList(uploadPath);
			String blackSubPath = EgovWebUtil.filePathBlackList(subPath);

			vo.setFileName(tmp);
			vo.setContentType(mFile.getContentType());
			vo.setServerPath(blackUploadPath);
			vo.setServerSubPath(blackSubPath);

			String physicalName = getPhysicalFileName();

			if (addExtension) {
				physicalName = physicalName + "." + FilenameUtils.getExtension(tmp).toLowerCase();
			}

			vo.setPhysicalName(physicalName);
			vo.setSize(mFile.getSize());
			vo.setExtension(FilenameUtils.getExtension(tmp).toLowerCase());
			System.out.println("dddddddppppppppppppp");
			System.out.println(FilenameUtils.getExtension(tmp).toLowerCase());
			if (mFile.getSize() > 0) {
				InputStream is = null;

				try {
					is = mFile.getInputStream();

					if (MimeTypeUtil.isNotAllowFile(is)) {
						throw new ApplicationException(AppConstants.FAIL,
								mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
					}

					saveFile(is, new File(EgovWebUtil.filePathBlackList(vo.getServerPath() + SEPERATOR
							+ vo.getServerSubPath() + SEPERATOR + vo.getPhysicalName()+ "." + FilenameUtils.getExtension(tmp).toLowerCase())));
				} finally {
					if (is != null) {
						is.close();
					}
				}
				list.add(vo);
			}
		}

		return list;
	}

	/**
	 * 파일을 Upload 처리한다.
	 *
	 * @param request
	 * @param uploadPath
	 * @param subPath
	 * @param maxFileSize
	 * @return
	 * @throws Exception
	 */
	public static List<EgovFormBasedFileVo> uploadFiles2(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize) throws Exception {
		return uploadFiles2(request, uploadPath, subPath, maxFileSize, false);
	}

	/**
	 * 파일을 Upload 처리한다.
	 *
	 * @param request
	 * @param uploadPath
	 * @param subPath
	 * @param maxFileSize
	 * @param addExtension
	 *            : application-xxx.properties 의 web.resource.upload.file(resource 접근 가능 파일 경로) 를 참조한 경우 확장자가 있어야지만 바로 열
	 *            수 있다.
	 * @return
	 * @throws Exception
	 */
	public static List<EgovFormBasedFileVo> uploadFiles2(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize, boolean addExtension) throws Exception {
		List<EgovFormBasedFileVo> list = new ArrayList<>();

		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
		Iterator<?> fileIter = mptRequest.getFileNames();

		while (fileIter.hasNext()) {
			MultipartFile mFile = mptRequest.getFile((String) fileIter.next());

			if (mFile.getSize() > maxFileSize) {
				throw new ApplicationException(AppConstants.FAIL,
						CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
								AppConstants.MSG_FILE_MAX_LIMT,
								new Object[] { CommonUtils.formatFileSize(maxFileSize) }));
			}

			EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

			String tmp = mFile.getOriginalFilename();

			if (tmp.lastIndexOf("\\") >= 0) {
				tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
			}

			String blackUploadPath = EgovWebUtil.filePathBlackList(uploadPath);
			String blackSubPath = EgovWebUtil.filePathBlackList(subPath);

			vo.setFileName(tmp);
			vo.setContentType(mFile.getContentType());
			vo.setServerPath(blackUploadPath);
			vo.setServerSubPath(blackSubPath);

			//String physicalName = getPhysicalFileName();
			String physicalName = tmp;

			if (addExtension) {
				physicalName = physicalName + "." + FilenameUtils.getExtension(tmp).toLowerCase();
			}

			vo.setPhysicalName(physicalName);
			vo.setSize(mFile.getSize());
			vo.setExtension(FilenameUtils.getExtension(tmp).toLowerCase());

			if (mFile.getSize() > 0) {
				InputStream is = null;

				try {
					is = mFile.getInputStream();

					if (MimeTypeUtil.isNotAllowFile(is)) {
						throw new ApplicationException(AppConstants.FAIL,
								mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
					}

					saveFile(is, new File(EgovWebUtil.filePathBlackList(vo.getServerPath() + SEPERATOR
							+ vo.getServerSubPath() + SEPERATOR + vo.getPhysicalName())));
				} finally {
					if (is != null) {
						is.close();
					}
				}
				list.add(vo);
			}
		}

		return list;
	}

	public static List<File> getUploadExcelFiles(MultipartHttpServletRequest request, String uploadDir) throws IOException {
		List<File> fileList = new ArrayList<>();
		Iterator<?> fileIter = request.getFileNames();
		long maxFileSize = AppConstants.UPLOAD_EXCEL_MAX_SIZE;

		while (fileIter.hasNext()) {
			MultipartFile mFile = request.getFile((String) fileIter.next());

			if (mFile.getSize() > maxFileSize) {
				throw new ApplicationException(AppConstants.FAIL,
						CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
								AppConstants.MSG_FILE_MAX_LIMT,
								new Object[] { CommonUtils.formatFileSize(maxFileSize) }));
			}

			EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

			String tmp = mFile.getOriginalFilename();

			if (tmp.lastIndexOf("\\") >= 0) {
				tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
			}

			String blackUploadPath = EgovWebUtil.filePathBlackList(uploadDir);
			String blackSubPath = EgovWebUtil.filePathBlackList("temp");

			vo.setFileName(tmp);
			vo.setContentType(mFile.getContentType());
			vo.setServerPath(blackUploadPath);
			vo.setServerSubPath(blackSubPath);

			String physicalName = UUIDGenerator.get().toUpperCase();
			vo.setPhysicalName(physicalName);
			vo.setSize(mFile.getSize());
			vo.setExtension(FilenameUtils.getExtension(tmp).toLowerCase());

			if (mFile.getSize() > 0) {
				InputStream is = null;
				File f;
				try {
					is = mFile.getInputStream();

					if (MimeTypeUtil.isNotAllowFile(is)) {
						throw new ApplicationException(AppConstants.FAIL,
								mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
					}
					f = new File(EgovWebUtil.filePathBlackList(
							blackUploadPath + SEPERATOR + blackSubPath + SEPERATOR + vo.getPhysicalName()) + "."
							+ vo.getExtension());
					EgovFormBasedFileUtil.saveFile(is, f);
				} finally {
					if (is != null) {
						is.close();
					}
				}

				fileList.add(f);
			}

		}
		return fileList;
	}

	public static List<EgovFormBasedFileVo> getUploadExcelFilesRVO(MultipartFile mFile, String uploadDir, String subPath) throws IOException {
		List<EgovFormBasedFileVo> fileList = new ArrayList<>();
		long maxFileSize = AppConstants.UPLOAD_EXCEL_MAX_SIZE;

		if (mFile.getSize() > maxFileSize) {
			throw new ApplicationException(AppConstants.FAIL,
					CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
							AppConstants.MSG_FILE_MAX_LIMT,
							new Object[] { CommonUtils.formatFileSize(maxFileSize) }));
		}

		EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

		String tmp = mFile.getOriginalFilename();

		if (tmp.lastIndexOf("\\") >= 0) {
			tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
		}

		String blackUploadPath = EgovWebUtil.filePathBlackList(uploadDir);
		String blackSubPath = EgovWebUtil.filePathBlackList(subPath);

		vo.setFileName(tmp);
		vo.setContentType(mFile.getContentType());
		vo.setServerPath(blackUploadPath);
		vo.setServerSubPath(blackSubPath);

		String physicalName = UUIDGenerator.get().toUpperCase();
		vo.setSize(mFile.getSize());
		vo.setExtension(FilenameUtils.getExtension(tmp).toLowerCase());
		vo.setPhysicalName(physicalName + "." + vo.getExtension());

		if (mFile.getSize() > 0) {
			InputStream is = null;
			File f;
			try {
				is = mFile.getInputStream();

				if (MimeTypeUtil.isNotAllowFile(is)) {
					throw new ApplicationException(AppConstants.FAIL,
							mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
				}
				f = new File(EgovWebUtil.filePathBlackList(
						blackUploadPath + SEPERATOR + blackSubPath + SEPERATOR + vo.getPhysicalName()));
				EgovFormBasedFileUtil.saveFile(is, f);
			} finally {
				if (is != null) {
					is.close();
				}
			}

			fileList.add(vo);
		}
		return fileList;
	}

	public static List<EgovFormBasedFileVo> uploadFilesNewName(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize, boolean addExtension, String tempFileName) throws Exception {
		List<EgovFormBasedFileVo> list = new ArrayList<>();

		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
		Iterator<?> fileIter = mptRequest.getFileNames();

		while (fileIter.hasNext()) {
			MultipartFile mFile = mptRequest.getFile((String) fileIter.next());

			if (mFile.getSize() > maxFileSize) {
				throw new ApplicationException(AppConstants.FAIL,
						CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
								AppConstants.MSG_FILE_MAX_LIMT,
								new Object[] { CommonUtils.formatFileSize(maxFileSize) }));
			}

			EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

			String tmp = tempFileName; //mFile.getOriginalFilename();

			if (tmp.lastIndexOf("\\") >= 0) {
				tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
			}

			String blackUploadPath = EgovWebUtil.filePathBlackList(uploadPath);
			String blackSubPath = EgovWebUtil.filePathBlackList(subPath);

			vo.setFileName(tmp);
			vo.setContentType(mFile.getContentType());
			vo.setServerPath(blackUploadPath);
			vo.setServerSubPath(blackSubPath);

			/*String physicalName = getPhysicalFileName();

			if (addExtension) {
				physicalName = physicalName + "." + FilenameUtils.getExtension(tmp).toLowerCase();
			}*/

			vo.setPhysicalName(tempFileName);
			vo.setSize(mFile.getSize());
			vo.setExtension(FilenameUtils.getExtension(tmp).toLowerCase());

			if (mFile.getSize() > 0) {
				InputStream is = null;

				try {
					is = mFile.getInputStream();

					if (MimeTypeUtil.isNotAllowFile(is)) {
						throw new ApplicationException(AppConstants.FAIL,
								mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
					}

					saveFile(is, new File(EgovWebUtil.filePathBlackList(vo.getServerPath() + SEPERATOR
							+ vo.getServerSubPath() + SEPERATOR + vo.getPhysicalName())));
				} finally {
					if (is != null) {
						is.close();
					}
				}
				list.add(vo);
			}
		}

		return list;
	}

	public static List<EgovFormBasedFileVo> uploadImageFilesWithCompress(HttpServletRequest request, String uploadPath, String subPath,
      final long maxFileSize, boolean addExtension) throws Exception {
    List<EgovFormBasedFileVo> list = new ArrayList<>();

    MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
    Iterator<?> fileIter = mptRequest.getFileNames();

    while (fileIter.hasNext()) {
      MultipartFile mFile = mptRequest.getFile((String) fileIter.next());

      if (mFile.getSize() > maxFileSize) {
        throw new ApplicationException(AppConstants.FAIL,
            CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
                AppConstants.MSG_FILE_MAX_LIMT,
                new Object[] { CommonUtils.formatFileSize(maxFileSize) }));
      }

      EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

      String tmp = mFile.getOriginalFilename();

      if (tmp.lastIndexOf("\\") >= 0) {
        tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
      }

      String blackUploadPath = EgovWebUtil.filePathBlackList(uploadPath);
      String blackSubPath = EgovWebUtil.filePathBlackList(subPath);

      vo.setFileName(tmp);
      vo.setContentType(mFile.getContentType());
      vo.setServerPath(blackUploadPath);
      vo.setServerSubPath(blackSubPath);

      String physicalName = getPhysicalFileName();

      if (addExtension) {
        physicalName = physicalName + "." + FilenameUtils.getExtension(tmp).toLowerCase();
      }

      vo.setPhysicalName(physicalName);
      //vo.setSize(mFile.getSize());
      vo.setExtension(FilenameUtils.getExtension(tmp).toLowerCase());

      if (mFile.getSize() > 0) {
        InputStream is = null;
        long size = 0L;

        try {
          is = mFile.getInputStream();

          if (MimeTypeUtil.isNotAllowFile(is)) {
            throw new ApplicationException(AppConstants.FAIL,
                mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
          }

          size = saveImageFile(is, new File(EgovWebUtil.filePathBlackList(vo.getServerPath() + SEPERATOR + vo.getServerSubPath() + SEPERATOR + vo.getPhysicalName())));

          vo.setSize(size);

        } finally {
          if (is != null) {
            is.close();
          }
        }
        list.add(vo);
      }
    }

    return list;
  }

	/**
	 * 파일을 Upload 처리한다.
	 *
	 * @param request
	 * @param uploadPath
	 * @param subPath
	 * @param maxFileSize
	 * @param addExtension
	 *            : application-xxx.properties 의 web.resource.upload.file(resource 접근 가능 파일 경로) 를 참조한 경우 확장자가 있어야지만 바로 열
	 *            수 있다.
	 * @return
	 * @throws Exception
	 */
	public static List<EgovFormBasedFileVo> uploadMemoFiles(HttpServletRequest request, String uploadPath, String subPath,
			final long maxFileSize, boolean addExtension) throws Exception {
		List<EgovFormBasedFileVo> list = new ArrayList<>();

		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) request;
		Iterator<?> fileIter = mptRequest.getFileNames();

		while (fileIter.hasNext()) {
			MultipartFile mFile = mptRequest.getFile((String) fileIter.next());

			if (mFile.getSize() > maxFileSize) {
				throw new ApplicationException(AppConstants.FAIL,
						CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
								AppConstants.MSG_FILE_MAX_LIMT,
								new Object[] { CommonUtils.formatFileSize(maxFileSize) }));
			}

			EgovFormBasedFileVo vo = new EgovFormBasedFileVo();

			String tmp = mFile.getOriginalFilename();

			if (tmp.lastIndexOf("\\") >= 0) {
				tmp = tmp.substring(tmp.lastIndexOf("\\") + 1);
			}

			String blackUploadPath = EgovWebUtil.filePathBlackList(uploadPath);
			String blackSubPath = EgovWebUtil.filePathBlackList(subPath);

			vo.setFileName(tmp);
			vo.setContentType(mFile.getContentType());
			vo.setServerPath(blackUploadPath);
			vo.setServerSubPath(blackSubPath);

			String physicalName = tmp;

/*			if (addExtension) {
				physicalName = physicalName + "." + FilenameUtils.getExtension(tmp).toLowerCase();
			}*/

			vo.setPhysicalName(physicalName);
			vo.setSize(mFile.getSize());
			vo.setExtension(FilenameUtils.getExtension(tmp).toLowerCase());

			if (mFile.getSize() > 0) {
				InputStream is = null;

				try {
					is = mFile.getInputStream();

					if (MimeTypeUtil.isNotAllowFile(is)) {
						throw new ApplicationException(AppConstants.FAIL,
								mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
					}

					saveFile(is, new File(EgovWebUtil.filePathBlackList(vo.getServerPath() + SEPERATOR
							+ vo.getServerSubPath() + SEPERATOR + vo.getPhysicalName())));
				} finally {
					if (is != null) {
						is.close();
					}
				}
				list.add(vo);
			}
		}

		return list;
	}

}
