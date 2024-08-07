package com.coway.trust.web.common.excel.download;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.cmmn.exception.ApplicationException;

/**
 * - 대용량 Excel 다운로드시 사용... (Use for large Excel download ...)
 */
@Controller
public class ExcelDownloadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ExcelDownloadController.class);

	@Autowired
	private LargeExcelService largeExcelService;

	@RequestMapping("/excelFile.do")
	public void excelFile(HttpServletRequest request, HttpServletResponse response) {
		ExcelDownloadHandler excelDownloadHandler = null;
		try {
			String fileName = request.getParameter("fileName");

			// 임시로 세팅...
			fileName = "test22222222222222222.xlsx";
			// 임시로 세팅...

			String[] columns = new String[] { "clctrId", "ordId", "strtgOs", "closOs", "isDrop",
					"isExclude", "runId", "taskId" };

			String[]  titles = new String[] { "clctrId", "ordId", "strtgOs", "closOs", "isDrop",
					"isExclude", "runId", "taskId" };

			ExcelDownloadVO excelDownloadVO = ExcelDownloadFormDef.getExcelDownloadVO(fileName, columns,
					titles);
			excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);

			Map map = new HashMap();
			map.put("taskId", "52");

			largeExcelService.downLoad13T(map, excelDownloadHandler);

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (excelDownloadHandler != null) {
				try {
					excelDownloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}
	}
}
