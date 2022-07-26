/**
 *
 */
package com.coway.trust.web.homecare.sales;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.common.SalesCommonService;
//import com.coway.trust.biz.sales.common.impl.SalesCommonMapper;
import com.coway.trust.biz.homecare.sales.htOrderListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Tommy
 *
 */
@Controller
@RequestMapping(value = "/homecare/sales")
public class htOrderListController {

	private static Logger logger = LoggerFactory.getLogger(htOrderListController.class);

	@Resource(name = "htOrderListService")
	private htOrderListService htOrderListService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/htOrderList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
			logger.info("memType ##### " + getUserInfo.get("memType"));
		}


		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "homecare/sales/htOrderList";
	}

	@RequestMapping(value = "/selectHTOrderJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHTOrderJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("memLevel", sessionVO.getMemberLevel());

		String[] arrAppType   = request.getParameterValues("appType"); //Application Type
		String[] arrOrdStusId = request.getParameterValues("ordStusId"); //Order Status
		String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId"); //Key-In Branch
		String[] arrDscBrnchId = request.getParameterValues("dscBrnchId"); //DSC Branch
		String[] arrRentStus = request.getParameterValues("rentStus"); //Rent Status
		String[] arrProductId = request.getParameterValues("productId"); //Product Id
		String[] arrUnitTypeId = request.getParameterValues("unitTypeId"); //Unit Type Id


		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");

    	params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("ordEndDt", CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))      params.put("arrAppType", arrAppType);
		if(arrOrdStusId    != null && !CommonUtils.containsEmpty(arrOrdStusId))    params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   != null && !CommonUtils.containsEmpty(arrDscBrnchId))   params.put("arrDscBrnchId", arrDscBrnchId);
		if(arrRentStus     != null && !CommonUtils.containsEmpty(arrRentStus))     params.put("arrRentStus", arrRentStus);
		if(arrProductId     != null && !CommonUtils.containsEmpty(arrProductId))     params.put("arrProductId", arrProductId);
		if(arrUnitTypeId     != null && !CommonUtils.containsEmpty(arrUnitTypeId))     params.put("arrUnitTypeId", arrUnitTypeId);


		if(params.get("custIc") == null) {logger.debug("!@###### custIc is null");}
		if("".equals(params.get("custIc"))) {logger.debug("!@###### custIc ''");}

		logger.debug("!@##############################################################################");
		logger.debug("!@###### ordNo : "+params.get("ordNo"));
		logger.debug("!@###### ordStartDt : "+params.get("ordStartDt"));
		logger.debug("!@###### ordEndDt : "+params.get("ordEndDt"));
		logger.debug("!@###### ordDt : "+params.get("ordDt"));
		logger.debug("!@###### custIc : "+params.get("custIc"));
		logger.debug("!@##############################################################################");

		 logger.debug("##### params : " + params);
		List<EgovMap> orderList = htOrderListService.selectOrderList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orderList);
	}


	@RequestMapping(value="/getApplicationTypeList")
	public ResponseEntity<List<EgovMap>> getApplicationTypeList(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> applicationTypeList = null;
		applicationTypeList = htOrderListService.getApplicationTypeList(params);

		return ResponseEntity.ok(applicationTypeList);
	}

	@RequestMapping(value="/getUserCodeList")
	public ResponseEntity<List<EgovMap>> getUserCodeList() throws Exception{

		List<EgovMap> userCodeList = null;
		userCodeList = htOrderListService.getUserCodeList();

		return ResponseEntity.ok(userCodeList);
	}

	@RequestMapping(value="/getOrgCodeList")
	public ResponseEntity<List<EgovMap>> getOrgCodeList(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> orgCodeList = null;
		orgCodeList = htOrderListService.getOrgCodeList(params);

		return ResponseEntity.ok(orgCodeList);
	}

	@RequestMapping(value="/getGrpCodeList")
	public ResponseEntity<List<EgovMap>> getGrpCodeList(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> grpCodeList = null;
		grpCodeList = htOrderListService.getGrpCodeList(params);

		return ResponseEntity.ok(grpCodeList);
	}

	@RequestMapping(value = "/getMemberOrgInfo.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getMemberOrgInfo(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

        EgovMap result = htOrderListService.getMemberOrgInfo(params);

        return ResponseEntity.ok(result);
    }

	@RequestMapping(value="/getBankCodeList")
	public ResponseEntity<List<EgovMap>> getBankCodeList(@RequestParam Map<String, Object> params) throws Exception{

		List<EgovMap> bankCodeList = null;
		bankCodeList = htOrderListService.getBankCodeList(params);

		return ResponseEntity.ok(bankCodeList);
	}

	@RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) {

		List<EgovMap> codeList = htOrderListService.selectCodeList(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value="/htOrderSOFListPop.do")
	public String orderSOFListPop(){

		return "homecare/sales/htOrderSOFListPop";
	}

	@RequestMapping(value="/htRawDataPop.do")
	public String htRawDataPop(){

		return "homecare/sales/htRawDataPop";
	}

	@RequestMapping(value="/htOrderPaymentListingPop.do")
	public String htOrderPaymentListingPop(){

		return "homecare/sales/htOrderPaymentListingPop";
	}
}
