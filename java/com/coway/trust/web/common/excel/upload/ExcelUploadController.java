package com.coway.trust.web.common.excel.upload;

import static com.coway.trust.cmmn.file.EgovFileUploadUtil.getUploadExcelFiles;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.biz.common.excel.upload.ExcelUploadService;

/**
 * - 대용량 Excel 업로드시 사용... (Use for large Excel upload ...)
 */
@Controller
public class ExcelUploadController {
	@Autowired
	private ExcelUploadService excelUploadService;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@RequestMapping(value = "/excelUpload.do", method = RequestMethod.POST)
	public ResponseEntity upload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params)
			throws IOException {

		List<File> fileList = getUploadExcelFiles(request, uploadDir);
		String[] columns = { "id", "firstName", "lastName" };
		excelUploadService.uploadExcelToDB(params, fileList.get(0), 0, columns);

		for (File file : fileList) {
			file.delete();
		}

		return ResponseEntity.ok(HttpStatus.OK);
	}

}
