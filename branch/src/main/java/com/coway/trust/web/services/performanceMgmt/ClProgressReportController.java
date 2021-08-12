package com.coway.trust.web.services.performanceMgmt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.performanceMgmt.ClProgressReportService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;
/**
 * @ClassName : ClProgressReportController.java
 * @Description : CL Progress Report Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 31.   KR-OHK        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/services/performanceMgmt")
public class ClProgressReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ClProgressReportController.class);

	@Resource(name = "clProgressReportService")
	private ClProgressReportService clProgressReportService;

	@RequestMapping(value = "/clProgressReport.do")
	public String clProgressReport(ModelMap model) throws Exception {

		String year = CommonUtils.getFormattedString("yyyy");
		model.put("year", year);

		return "services/performanceMgmt/clProgressReport";
	}

	@RequestMapping(value = "/selectClProgressReportList", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectClProgressReportList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();

		if("STS".equals(params.get("tabId"))) {

			List<EgovMap> gcmList = clProgressReportService.selectGcmList(params);
			List<EgovMap> scmList = clProgressReportService.selectScmList(params);
			List<EgovMap> cmList = clProgressReportService.selectCmList(params);
			List<EgovMap> codyList = clProgressReportService.selectCodyList(params);

			map.put("gcmList", gcmList);
			map.put("scmList", scmList);
			map.put("cmList", cmList);
			map.put("codyList", codyList);

		} else  if("HS".equals(params.get("tabId"))) {

			List<EgovMap> hsList = clProgressReportService.selectHearServiceList(params);
			map.put("hsList", hsList);

		} else  if("RC".equals(params.get("tabId"))) {

			List<EgovMap> rcList = clProgressReportService.selectRentalCollectionList(params);
			map.put("rcList", rcList);

		} else  if("SN".equals(params.get("tabId"))) {

			List<EgovMap> appList = clProgressReportService.selectSalesNetAppList(params);
			List<EgovMap> catList = clProgressReportService.selectSalesNetCatList(params);

			map.put("appList", appList);
			map.put("catList", catList);

		} else  if("RJ".equals(params.get("tabId"))) {

			List<EgovMap> rjList = clProgressReportService.selectRejoinList(params);

			map.put("rjList", rjList);

		} else  if("MBO".equals(params.get("tabId"))) {

			List<EgovMap> salesList = clProgressReportService.selectMBOSalesList(params);
			List<EgovMap> svmList = clProgressReportService.selectMBOSVMList(params);

			map.put("salesList", salesList);
			map.put("svmList", svmList);

		} else  if("RT".equals(params.get("tabId"))) {

			List<EgovMap> rtList = clProgressReportService.selectRetentionList(params);
			map.put("rtList", rtList);

		} else  if("CFF".equals(params.get("tabId"))) {

			List<EgovMap> cffList = clProgressReportService.selectCFFList(params);
			map.put("cffList", cffList);

		} else  if("PE".equals(params.get("tabId"))) {

			List<EgovMap> peList = clProgressReportService.selectPEAList(params);
			map.put("peList", peList);

		}

		return ResponseEntity.ok(map);
	}
}
