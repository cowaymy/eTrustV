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

import com.coway.trust.biz.services.performanceMgmt.CodyPerformanceReportService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;
/**
 * @ClassName : CodyPerformanceReportController.java
 * @Description : Cody Performance Report Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 06.   KR-OHK        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/services/performanceMgmt")
public class CodyPerformanceReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CodyPerformanceReportController.class);

	@Resource(name = "codyPerformanceReportService")
	private CodyPerformanceReportService codyPerformanceReportService;

	@RequestMapping(value = "/codyPerformanceReport.do")
	public String codyPerformanceReport(ModelMap model) throws Exception {

		String mmyyyy = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);
		model.put("mmyyyy", mmyyyy);

		return "services/performanceMgmt/codyPerformanceReport";
	}

	@RequestMapping(value = "/selectCodyPerformanceReportList", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectCodyPerformanceReportList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();

		if("HC".equals(params.get("tabId"))) {

			List<EgovMap> hcList = codyPerformanceReportService.selectCodyHCList(params);

			map.put("hcList", hcList);

		} else  if("HS".equals(params.get("tabId"))) {

			List<EgovMap> hsOaList = codyPerformanceReportService.selectCodyHSOverallList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); // Individual(964)
			List<EgovMap> hsInList = codyPerformanceReportService.selectCodyHSList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_COMPANY);   // Corporate(965)
			List<EgovMap> hsCoList = codyPerformanceReportService.selectCodyHSList(params);
			List<EgovMap> hsCoRtList = codyPerformanceReportService.selectCodyHSCorporateRatioList(params);

			map.put("hsOaList", hsOaList);
			map.put("hsInList", hsInList);
			map.put("hsCoList", hsCoList);
			map.put("hsCoRtList", hsCoRtList);

		} else  if("RC".equals(params.get("tabId"))) {

			List<EgovMap> rcOaList = codyPerformanceReportService.selectCodyRCOverallList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); // Individual(964)
			List<EgovMap> rcInList = codyPerformanceReportService.selectCodyRCList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_COMPANY);   // Corporate(965)
			List<EgovMap> rcCoList = codyPerformanceReportService.selectCodyRCList(params);

			map.put("rcOaList", rcOaList);
			map.put("rcInList", rcInList);
			map.put("rcCoList", rcCoList);

		} else  if("SALES".equals(params.get("tabId"))) {

			List<EgovMap> salesOaList = codyPerformanceReportService.selectCodySalesOverallList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); // Individual(964)
			List<EgovMap> salesInList = codyPerformanceReportService.selectCodySalesList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_COMPANY);   // Corporate(965)
			List<EgovMap> salesCoList = codyPerformanceReportService.selectCodySalesList(params);

			map.put("salesOaList", salesOaList);
			map.put("salesInList", salesInList);
			map.put("salesCoList", salesCoList);

		} else  if("SVM".equals(params.get("tabId"))) {

			List<EgovMap> svmOaList = codyPerformanceReportService.selectCodySVMOverallList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); // Individual(964)
			List<EgovMap> svmInList = codyPerformanceReportService.selectCodySVMList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_COMPANY);   // Corporate(965)
			List<EgovMap> svmCoList = codyPerformanceReportService.selectCodySVMList(params);

			map.put("svmOaList", svmOaList);
			map.put("svmInList", svmInList);
			map.put("svmCoList", svmCoList);

		} else  if("RT".equals(params.get("tabId"))) {

			List<EgovMap> rtOaList = codyPerformanceReportService.selectCodyRTOverallList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_INDIVIDUAL); // Individual(964)
			List<EgovMap> rtInList = codyPerformanceReportService.selectCodyRTList(params);
			params.put("typeId", SalesConstants.APPLICANT_TYPE_ID_COMPANY);   // Corporate(965)
			List<EgovMap> rtCoList = codyPerformanceReportService.selectCodyRTList(params);

			map.put("rtOaList", rtOaList);
			map.put("rtInList", rtInList);
			map.put("rtCoList", rtCoList);

		} else  if("CFF".equals(params.get("tabId"))) {

			List<EgovMap> cffList = codyPerformanceReportService.selectCodyCFFOverallList(params);

			map.put("cffList", cffList);

		} else  if("PE".equals(params.get("tabId"))) {

			List<EgovMap> peList = codyPerformanceReportService.selectCodyPEList(params);

			map.put("peList", peList);

		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectMemberInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectMemberInfo(@RequestParam Map<String, Object> params) throws Exception {
	    EgovMap result = codyPerformanceReportService.selectMemberInfo(params);
	    return ResponseEntity.ok(result);
	}
}
