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

import com.coway.trust.biz.services.performanceMgmt.GcmProgressReportService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;
/**
 * @ClassName : GcmProgressReportController.java
 * @Description : GCM Progress Report Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.   KR-OHK        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/services/performanceMgmt")
public class GcmProgressReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GcmProgressReportController.class);

	@Resource(name = "gcmProgressReportService")
	private GcmProgressReportService gcmProgressReportService;

	@RequestMapping(value = "/gcmProgressReport.do")
	public String gcmProgressReport(ModelMap model) throws Exception {

		String mmyyyy = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);
		String year = CommonUtils.getFormattedString("yyyy");

		model.put("year", year);
		model.put("mmyyyy", mmyyyy);

		return "services/performanceMgmt/gcmProgressReport";
	}

	@RequestMapping(value = "/selectMemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemList(@RequestParam Map<String, Object> params) throws Exception {

		LOGGER.debug("emplyLev : {}", params.get("emplyLev"));

		List<EgovMap> codeList = gcmProgressReportService.selectMemList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectGcmProgressReportList", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectGcmProgressReportList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();

		if("STS".equals(params.get("tabId"))) {

			List<EgovMap> scmList = gcmProgressReportService.selectScmList(params);
			List<EgovMap> cmList = gcmProgressReportService.selectCmList(params);
			List<EgovMap> codyList = gcmProgressReportService.selectCodyList(params);

			map.put("scmList", scmList);
			map.put("cmList", cmList);
			map.put("codyList", codyList);

		} else if("CRD".equals(params.get("tabId"))) {

			List<EgovMap> codyLowList = gcmProgressReportService.selectCodyRowDataList(params);

			map.put("codyLowList", codyLowList);

		} else  if("HS".equals(params.get("tabId"))) {

			List<EgovMap> hsList = gcmProgressReportService.selectHearServiceList(params);
			map.put("hsList", hsList);

		} else  if("RC".equals(params.get("tabId"))) {

			List<EgovMap> rcList = gcmProgressReportService.selectRentalCollectionList(params);
			map.put("rcList", rcList);

		} else  if("SN".equals(params.get("tabId"))) {

			List<EgovMap> snList = gcmProgressReportService.selectSalesNetList(params);
			map.put("snList", snList);

		} else  if("SP".equals(params.get("tabId"))) {

			List<EgovMap> spList = gcmProgressReportService.selectSalesProdList(params);
			map.put("spList", spList);

		} else  if("RJ".equals(params.get("tabId"))) {

			List<EgovMap> rjList = gcmProgressReportService.selectRejoinList(params);

			map.put("rjList", rjList);

		} else  if("MBO".equals(params.get("tabId"))) {

			List<EgovMap> salesList = gcmProgressReportService.selectMBOSalesList(params);
			List<EgovMap> svmList = gcmProgressReportService.selectMBOSVMList(params);

			map.put("salesList", salesList);
			map.put("svmList", svmList);

		} else  if("RT".equals(params.get("tabId"))) {

			List<EgovMap> rtList = gcmProgressReportService.selectRetentionList(params);
			map.put("rtList", rtList);

		} else  if("CFF".equals(params.get("tabId"))) {

			List<EgovMap> cffList = gcmProgressReportService.selectCFFList(params);
			map.put("cffList", cffList);

		} else  if("PE".equals(params.get("tabId"))) {

			List<EgovMap> gcmpeList = gcmProgressReportService.selectGcmPEList(params);
			List<EgovMap> scmpeList = gcmProgressReportService.selectScmPEAList(params);
			List<EgovMap> cmpeList = gcmProgressReportService.selectCmPEAList(params);
			List<EgovMap> codypeList = gcmProgressReportService.selectCodyPEAList(params);

			map.put("gcmpeList", gcmpeList);
			map.put("scmpeList", scmpeList);
			map.put("cmpeList", cmpeList);
			map.put("codypeList", codypeList);
		}

		return ResponseEntity.ok(map);
	}
}
