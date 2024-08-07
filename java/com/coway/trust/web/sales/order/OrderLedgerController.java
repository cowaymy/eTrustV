package com.coway.trust.web.sales.order;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.payment.payment.service.PayDVO;
import com.coway.trust.biz.sales.order.OrderLedgerService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderLedgerController {

	private static final Logger logger = LoggerFactory.getLogger(OrderLedgerController.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "accessMonitoringService")
	private AccessMonitoringService accessMonitoringService;

	@Resource(name = "orderLedgerService")
	private OrderLedgerService orderLedgerService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/orderLedgerViewPop.do")
	public String orderLedgerViewPop(@RequestParam Map<String, Object>params, ModelMap model, HttpServletRequest request){

		logger.debug("params ======================================>>> " + params);

		if(CommonUtils.isEmpty(params.get("CutOffDate"))){
			params.put("CutOffDate", "01/01/1900");
		}

    	//Log down user search params
        SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    	StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
    	requestUrl.replace(requestUrl.lastIndexOf("/"), requestUrl.lastIndexOf("/") + 1, "/orderLedgerViewPop.do/");
		accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

		EgovMap orderInfo = orderLedgerService.selectOrderLedgerView(params);
		model.addAttribute("orderInfo", orderInfo);

		EgovMap insInfo = orderLedgerService.selectInsInfo(params);
		model.addAttribute("insInfo", insInfo);

		EgovMap mailInfo = orderLedgerService.selectMailInfo(params);
		model.addAttribute("mailInfo", mailInfo);

		EgovMap salesInfo = orderLedgerService.selectSalesInfo(params);
		model.addAttribute("salesInfo", salesInfo);

		List<EgovMap> orderLdgrList = orderLedgerService.getOderLdgr(params);

		double balance = 0;
		for(int i = 0; i < orderLdgrList.size(); i++){
			EgovMap result = orderLdgrList.get(i);

			 if (result.get("docType") == "B/F")
             {
					balance = Double.parseDouble(result.get("balanceamt").toString());
             }
             else
             {
                 balance = balance + Double.parseDouble(result.get("debitamt").toString()) + Double.parseDouble(result.get("creditamt").toString());
             }

			 result.put("balanceamt", balance);

		}

		model.addAttribute("orderLdgrList", new Gson().toJson(orderLdgrList));

		List<EgovMap> agreList = orderLedgerService.selectAgreInfo(params);
		model.addAttribute("agreList", new Gson().toJson(agreList));

		List<EgovMap> ordOutInfoList = orderLedgerService.getOderOutsInfo(params);

		EgovMap ordOutInfo = ordOutInfoList.get(0);

		logger.debug("ordOutInfo =====================>>> " + ordOutInfo);

		model.addAttribute("ordOutInfo", ordOutInfo);

		return "sales/order/orderLedgerPop";
	}

	@RequestMapping(value = "/orderLedger2ViewPop.do")
	public String orderLedger2ViewPop(@RequestParam Map<String, Object>params, ModelMap model, HttpServletRequest request){

		logger.debug("params ======================================>>> " + params);

		if(CommonUtils.isEmpty(params.get("CutOffDate"))){
			params.put("CutOffDate", "01/01/1900");
		}

    	//Log down user search params
        SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    	StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
    	requestUrl.replace(requestUrl.lastIndexOf("/"), requestUrl.lastIndexOf("/") + 1, "/orderLedger2ViewPop.do/");
		accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

		EgovMap orderInfo = orderLedgerService.selectOrderLedgerView(params);
		model.addAttribute("orderInfo", orderInfo);

		EgovMap insInfo = orderLedgerService.selectInsInfo(params);
		model.addAttribute("insInfo", insInfo);

		EgovMap mailInfo = orderLedgerService.selectMailInfo(params);
		model.addAttribute("mailInfo", mailInfo);

		EgovMap salesInfo = orderLedgerService.selectSalesInfo(params);
		model.addAttribute("salesInfo", salesInfo);

		List<EgovMap> orderLdgrList = orderLedgerService.getOderLdgr2(params);


		double balance = 0;
		for(int i = 0; i < orderLdgrList.size(); i++){
			EgovMap result = orderLdgrList.get(i);

			 if (result.get("docType") == "B/F")
             {
					balance = Double.parseDouble(result.get("balanceamt").toString());
             }
             else
             {
                 balance = balance + Double.parseDouble(result.get("debitamt").toString()) + Double.parseDouble(result.get("creditamt").toString());
             }

			 result.put("balanceamt", balance);

		}

		model.addAttribute("orderLdgrList", new Gson().toJson(orderLdgrList));

		List<EgovMap> agreList = orderLedgerService.selectAgreInfo(params);
		model.addAttribute("agreList", new Gson().toJson(agreList));

		List<EgovMap> ordOutInfoList = orderLedgerService.getOderOutsInfo(params);

		EgovMap ordOutInfo = ordOutInfoList.get(0);

		logger.debug("ordOutInfo =====================>>> " + ordOutInfo);

		model.addAttribute("ordOutInfo", ordOutInfo);

		return "sales/order/orderLedger2Pop";
	}

	@RequestMapping(value = "/orderLedgerDetailPop.do")
	public String orderLedgerDetail(@RequestParam Map<String, Object>params, ModelMap model){

		logger.debug("in  orderLedgerDetail ");

		logger.debug("param ===================>>  " + params);
		List<EgovMap> ordLdgDetailInfoList  = new ArrayList<>();

			if(!params.get("docNo").toString().equals("-")){

				logger.debug("" + params.get("docTypeId"));

				if(params.get("docTypeId")== "155"||params.get("docTypeId") == "157"){

					ordLdgDetailInfoList  = orderLedgerService.selectPaymentDetailViewCndn(params);
				}else{

					ordLdgDetailInfoList  = orderLedgerService.selectPaymentDetailView(params);
				}

			}

			model.addAttribute("ordLdgDetailInfoList", new Gson().toJson(ordLdgDetailInfoList ));

			return "sales/order/orderLedger2DetailPop";
	}

	@RequestMapping(value = "/selectPayInfo", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectPayInfo(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		EgovMap result = orderLedgerService.selectPayInfo(params);

		return ResponseEntity.ok(result);
	}


}