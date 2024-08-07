package com.coway.trust.web.services.servicePlanning.excel;

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
import com.coway.trust.web.commission.CommissionConstants;
import com.coway.trust.web.common.excel.download.ExcelDownloadFormDef;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;

/**
 * - 대용량 Excel 다운로드시 사용... (Use for large Excel download ...)
 */
@Controller
@RequestMapping(value = "/services/mileageCileage/excel")
public class DCPMgmtExcelDownloadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(DCPMgmtExcelDownloadController.class);

	@Autowired
	private LargeExcelService largeExcelService;

	@RequestMapping("/downloadExcelFile.do")
	public void excelFile(HttpServletRequest request, HttpServletResponse response) {
		ExcelDownloadHandler downloadHandler = null;
		try {
			String fileName = request.getParameter("fileName");
			
			String memType = request.getParameter("memType");
			String cityFrom = request.getParameter("cityFrom");
			String mcpFrom = request.getParameter("mcpFrom");
			String mcpFromID = request.getParameter("mcpFromID");
			LOGGER.debug("mcpFrom : " + mcpFrom + " / mcpFromID : " + mcpFromID);
			String cityTo = request.getParameter("cityTo");
			String mcpTo = request.getParameter("mcpTo");
			String mcpToID = request.getParameter("mcpToID");
			String brnch = request.getParameter("brnch");
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("memType", memType);
			map.put("cityFrom", cityFrom);
			map.put("mcpFrom", mcpFrom);
			map.put("mcpFromID", mcpFromID);
			map.put("cityTo", cityTo);
			map.put("mcpTo", mcpTo);
			map.put("mcpToID", mcpToID);
			map.put("brnch", brnch);
			
			String[] columns;
			String[] titles;

			columns = new String[] { "rnum", "memType", "brnchCode", "cityFrom", "dcpFrom", "dcpFromId", 
											"cityTo", "dcpTo", "dcpToId", "distance" };
			titles = new String[] { "No.", "Member Type", "Branch", "City From", "DCP From", "DCP From ID", 
											"City To", "DCP To", "DCP To ID", "Distance" };
			
			downloadHandler = getExcelDownloadHandler(response, fileName, columns, titles);

			largeExcelService.downLoadDCPMaster(map, downloadHandler);

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}
	}

	private ExcelDownloadHandler getExcelDownloadHandler(HttpServletResponse response, String fileName,
			String[] columns, String[] titles) {
		ExcelDownloadVO excelDownloadVO = ExcelDownloadFormDef.getExcelDownloadVO(fileName, columns, titles);
		return new ExcelDownloadHandler(excelDownloadVO, response);
	}
}
