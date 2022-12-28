package com.coway.trust.web.organization.organization;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.organization.organization.SalesMonitoringFileService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class SalesMonitoringFileController {

    private static final Logger LOGGER = LoggerFactory.getLogger(SalesMonitoringFileController.class);

    @Resource(name = "SalesMonitoringFileService")
    private SalesMonitoringFileService salesMonitoringFileService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Autowired
	private SessionHandler sessionHandler;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @RequestMapping(value = "/salesMonitoringFile.do")
	public String salesMonitoringListing(@RequestParam Map<String, Object> params, ModelMap model) {


    	EgovMap checkCurrentYearMonth = salesMonitoringFileService.checkCurrentYearMonth();

		model.put("month", checkCurrentYearMonth.get("currentm").toString() ==null ? "0":checkCurrentYearMonth.get("currentm").toString());
		model.put("currentYm", checkCurrentYearMonth.get("currentym").toString() ==null ? "0":checkCurrentYearMonth.get("currentym").toString());
		model.put("previousYm", checkCurrentYearMonth.get("previousym").toString() ==null ? "0":checkCurrentYearMonth.get("previousym").toString());
		model.put("previousYm2", checkCurrentYearMonth.get("previousym2").toString() ==null ? "0":checkCurrentYearMonth.get("previousym2").toString());
		model.put("previousYm3", checkCurrentYearMonth.get("previousym3").toString() ==null ? "0":checkCurrentYearMonth.get("previousym3").toString());

		return "organization/organization/salesMonitoringListing";
	}

	@RequestMapping(value = "/selectSummarySalesListing.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectSummarySalesListing(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

        List<EgovMap> notice = salesMonitoringFileService.selectSummarySalesListing(params);
        return ResponseEntity.ok(notice);
    }

	@RequestMapping(value = "/selectWeekSalesListing.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectWeekSalesListing(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

        List<EgovMap> notice = salesMonitoringFileService.selectWeekSalesListing(params);
        return ResponseEntity.ok(notice);
    }

	@RequestMapping(value = "/performanceView.do")
	public String performanceView(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
		}

		return "organization/organization/performanceView";
	}

	@RequestMapping(value = "/selectPerformanceView.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectPerformanceView(@RequestParam Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {

	    String[] cmbProductCtgry = request.getParameterValues("cmbProductCtgry");
	    String[] cmbProduct = request.getParameterValues("cmbProduct");

		params.put("cmbProduct", cmbProduct);
		params.put("cmbProductCtgry",cmbProductCtgry);

		EgovMap checkCurrentYearMonth = salesMonitoringFileService.checkCurrentYearMonth();

		if(checkCurrentYearMonth == null){
			params.put("month", "0");
			params.put("currentYm", "0");
			params.put("previousYm", "0");
		}
		else{
			params.put("month", checkCurrentYearMonth.get("currentm").toString() ==null ? "0":checkCurrentYearMonth.get("currentm").toString());
			params.put("currentYm", checkCurrentYearMonth.get("currentym"));
			params.put("previousYm", checkCurrentYearMonth.get("previousym"));
			params.put("previousYm3", checkCurrentYearMonth.get("previousym3"));
		}

        List<EgovMap> notice = salesMonitoringFileService.selectPerformanceView(params);
        return ResponseEntity.ok(notice);
    }

	@RequestMapping(value="/smfDailyInfoPop.do")
	public String smfDailyInfoPop(@RequestParam Map<String, Object> params, ModelMap model) {


		EgovMap checkCurrentYearMonth = salesMonitoringFileService.checkCurrentYearMonth();

		model.put("month", checkCurrentYearMonth.get("currentm").toString() ==null ? "0":checkCurrentYearMonth.get("currentm").toString());
		model.put("currentYm", checkCurrentYearMonth.get("currentym").toString() ==null ? "0":checkCurrentYearMonth.get("currentym").toString());
		model.put("previousYm", checkCurrentYearMonth.get("previousym").toString() ==null ? "0":checkCurrentYearMonth.get("previousym").toString());
		model.put("previousYm2", checkCurrentYearMonth.get("previousym2").toString() ==null ? "0":checkCurrentYearMonth.get("previousym2").toString());
		model.put("previousYm3", checkCurrentYearMonth.get("previousym3").toString() ==null ? "0":checkCurrentYearMonth.get("previousym3").toString());

		model.put("orgCode", params.get("orgCode"));
		model.put("grpCode", params.get("grpCode"));
		model.put("deptCode", params.get("deptCode"));
		model.put("memCode", params.get("memCode"));
		model.put("position", params.get("position"));

		return "organization/organization/smfDailyInfoPop";
	}

	@RequestMapping(value = "/selectSmfDailyListing.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectSmfDailyListing(@RequestParam Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {

        List<EgovMap> notice = salesMonitoringFileService.selectSmfDailyListing(params);
        return ResponseEntity.ok(notice);
    }

	@RequestMapping(value="/smfActHpPop.do")
	public String smfActHpPop(@RequestParam Map<String, Object> params, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
		}
		return "organization/organization/smfActHpPop";
	}


	@RequestMapping(value = "/selectSmfActHp.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectSmfActHp(@RequestParam Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {

	    String[] cmbProductCtgry = request.getParameterValues("cmbProductCtgry_actHP");
	    String[] cmbProduct = request.getParameterValues("cmbProduct_actHP");

		params.put("cmbProduct_actHP", cmbProduct);
		params.put("cmbProductCtgry_actHP",cmbProductCtgry);

		EgovMap checkCurrentYearMonth = salesMonitoringFileService.checkCurrentYearMonth();

		if(checkCurrentYearMonth == null){
			params.put("month", "0");
			params.put("currentYm", "0");
			params.put("previousYm", "0");
		}
		else{
			params.put("month", checkCurrentYearMonth.get("currentm").toString() ==null ? "0":checkCurrentYearMonth.get("currentm").toString());
			params.put("currentYm", checkCurrentYearMonth.get("currentym"));
			params.put("previousYm", checkCurrentYearMonth.get("previousym"));
			params.put("previousYm3", checkCurrentYearMonth.get("previousym3"));
		}


        List<EgovMap> notice = salesMonitoringFileService.selectSmfActHp(params);
        return ResponseEntity.ok(notice);
    }


	@RequestMapping(value="/smfHAPop.do")
	public String smfHAPop(@RequestParam Map<String, Object> params, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
		}

		return "organization/organization/smfHAPop";
	}

	@RequestMapping(value = "/selectSmfHA.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectSmfHA(@RequestParam Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {

	    String[] cmbProductCtgry = request.getParameterValues("cmbProductCtgry_HA");
	    String[] cmbProduct = request.getParameterValues("cmbProduct_HA");

		params.put("cmbProduct_HA", cmbProduct);
		params.put("cmbProductCtgry_HA",cmbProductCtgry);

		EgovMap checkCurrentYearMonth = salesMonitoringFileService.checkCurrentYearMonth();

		if(checkCurrentYearMonth == null){
			params.put("month", "0");
			params.put("currentYm", "0");
			params.put("previousYm", "0");
		}
		else{
			params.put("month", checkCurrentYearMonth.get("currentm").toString() ==null ? "0":checkCurrentYearMonth.get("currentm").toString());
			params.put("currentYm", checkCurrentYearMonth.get("currentym"));
			params.put("previousYm", checkCurrentYearMonth.get("previousym"));
			params.put("previousYm3", checkCurrentYearMonth.get("previousym3"));
		}


        List<EgovMap> notice = salesMonitoringFileService.selectSmfHA(params);
        return ResponseEntity.ok(notice);
    }

	@RequestMapping(value="/smfHCPop.do")
	public String smfHCPop(@RequestParam Map<String, Object> params, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
		}
		return "organization/organization/smfHCPop";
	}

	@RequestMapping(value = "/selectSmfHC.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectSmfHC(@RequestParam Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {

	    String[] cmbProductCtgry = request.getParameterValues("cmbProductCtgry_HC");
	    String[] cmbProduct = request.getParameterValues("cmbProduct_HC");

		params.put("cmbProduct_HC", cmbProduct);
		params.put("cmbProductCtgry_HC",cmbProductCtgry);

		EgovMap checkCurrentYearMonth = salesMonitoringFileService.checkCurrentYearMonth();

		if(checkCurrentYearMonth == null){
			params.put("month", "0");
			params.put("currentYm", "0");
			params.put("previousYm", "0");
		}
		else{
			params.put("month", checkCurrentYearMonth.get("currentm").toString() ==null ? "0":checkCurrentYearMonth.get("currentm").toString());
			params.put("currentYm", checkCurrentYearMonth.get("currentym"));
			params.put("previousYm", checkCurrentYearMonth.get("previousym"));
			params.put("previousYm3", checkCurrentYearMonth.get("previousym3"));
		}


        List<EgovMap> notice = salesMonitoringFileService.selectSmfHC(params);
        return ResponseEntity.ok(notice);
    }

	@RequestMapping(value = "/selectSimulatedMemberCRSCode.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectSimulatedMemberCRSCode(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

        List<EgovMap> notice = salesMonitoringFileService.selectSimulatedMemberCRSCode(params);
        return ResponseEntity.ok(notice);
    }

	@RequestMapping(value = "/cmbProduct_HA.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> cmbProduct_HA(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> colorGridProductList = salesMonitoringFileService.cmbProduct_HA();

		return ResponseEntity.ok(colorGridProductList);
	}

	@RequestMapping(value = "/cmbProduct_HC.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> cmbProduct_HC(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> colorGridProductList = salesMonitoringFileService.cmbProduct_HC();

		return ResponseEntity.ok(colorGridProductList);
	}

	@RequestMapping(value = "/selectProductCategoryList_HA.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductCategoryList_HA(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> colorGridProductList = salesMonitoringFileService.selectProductCategoryList_HA();

		return ResponseEntity.ok(colorGridProductList);
	}

	@RequestMapping(value = "/selectProductCategoryList_HC.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductCategoryList_HC(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> colorGridProductList = salesMonitoringFileService.selectProductCategoryList_HC();

		return ResponseEntity.ok(colorGridProductList);
	}



}
