package com.coway.trust.web.editor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.util.EgovFormBasedFileUtil;
import com.coway.trust.util.EgovFormBasedFileVo;

/**
 * 웹에디터 이미지 upload 처리 Controller
 * 
 * @author 공통컴포넌트개발팀 한성곤
 * @since 2009.08.26
 * @version 1.0
 * @see
 *
 *      <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.08.26  한성곤          최초 생성
 *
 *      </pre>
 */
@Controller
@RequestMapping(value = "/editor")
public class EgovWebEditorImageController {

	private static final long IMGAE_MAX_FILE_SIZE = 1024 * 1024 * 10; // 업로드 최대 사이즈 설정 (10M)
	private static final String IMAGE_SUB_PATH = "editor";

	/** 첨부파일 위치 지정 */
	@Value("${web.resource.upload.file}")
	private String uploadDir;

	/**
	 * 이미지 Upload 화면으로 이동한다.
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/uploadImagePop.do", method = RequestMethod.GET)
	public String goInsertImage() throws Exception {

		return "editor/egovInsertImagePop";
	}

	/**
	 * 이미지 Upload를 처리한다.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/uploadImagePop.do", method = RequestMethod.POST)
	public String imageUpload(HttpServletRequest request, Model model) throws Exception {
		// Spring multipartResolver 미사용 시 (commons-fileupload 활용)
		// List<EgovFormBasedFileVo> list = EgovFormBasedFileUtil.uploadFiles(request, uploadDir, maxFileSize);

		// Spring multipartResolver 사용시
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, IMAGE_SUB_PATH,
				IMGAE_MAX_FILE_SIZE);

		if (list.size() > 0) {
			EgovFormBasedFileVo vo = list.get(0); // 첫번째 이미지

			String url = request.getContextPath() + "/editor/imageSrc.do?" + "path=" + vo.getServerSubPath()
					+ "&physical=" + vo.getPhysicalName() + "&contentType=" + vo.getContentType();

			model.addAttribute("url", url);
		}

		return "editor/egovInsertImagePop";
	}

	/**
	 * 이미지 view를 제공한다.
	 *
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/imageSrc.do", method = RequestMethod.GET)
	public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String subPath = request.getParameter("path");
		String physical = request.getParameter("physical");
		String mimeType = request.getParameter("contentType");

		EgovFormBasedFileUtil.viewFile(response, uploadDir, subPath, physical, mimeType);
	}
}
