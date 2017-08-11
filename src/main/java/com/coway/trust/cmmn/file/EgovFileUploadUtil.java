package com.coway.trust.cmmn.file;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
	 *            TODO
	 * @param subPath
	 * @param maxFileSize
	 * @return
	 * @throws Exception
	 */
	public static List<EgovFormBasedFileVo> uploadFiles(HttpServletRequest request, final String uploadPath,
			final String subPath, final long maxFileSize) throws Exception {
		List<EgovFormBasedFileVo> list = new ArrayList<EgovFormBasedFileVo>();

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

			vo.setFileName(tmp);
			vo.setContentType(mFile.getContentType());
			vo.setServerPath(uploadPath);
			vo.setServerSubPath(subPath);
			vo.setPhysicalName(getPhysicalFileName());
			vo.setSize(mFile.getSize());

			if (tmp.lastIndexOf(".") >= 0) {
				vo.setPhysicalName(vo.getPhysicalName()); // 2012.11 KISA 보안조치
			}

			if (mFile.getSize() > 0) {
				InputStream is = null;

				try {
					is = mFile.getInputStream();

					if (MimeTypeUtil.isNotAllowFile(is)) {
						throw new ApplicationException(AppConstants.FAIL,
								mFile.getOriginalFilename() + AppConstants.MSG_IS_NOT_ALLOW);
					}

					saveFile(is,
							new File(EgovWebUtil.filePathBlackList(EgovWebUtil.filePathBlackList(uploadPath) + SEPERATOR
									+ EgovWebUtil.filePathBlackList(vo.getServerSubPath()) + SEPERATOR
									+ vo.getPhysicalName())));
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
