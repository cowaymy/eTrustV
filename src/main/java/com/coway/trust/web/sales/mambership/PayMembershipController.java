/**
 *
 */
package com.coway.trust.web.sales.mambership;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.mambership.MembershipQuotationService;
import com.coway.trust.biz.sales.mambership.MembershipRentalService;
import com.coway.trust.biz.sales.mambership.MembershipService;
import com.coway.trust.biz.sales.mambership.PayPopService;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
@Controller
@RequestMapping(value = "/sales/payPop")
public class PayMembershipController {

	private static Logger logger = LoggerFactory.getLogger(PayMembershipController.class);

	@Resource(name = "membershipQuotationService")
	private MembershipQuotationService membershipQuotationService;

	@Resource(name = "membershipService")
	private MembershipService membershipService;

	@Resource(name = "membershipRentalService")
	private MembershipRentalService  membershipRentalService;

	@Resource(name = "payPopService")
	private PayPopService  payPopService;


	@RequestMapping(value = "/quotationListPop.do")
	public String quotationListPop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("params ======================================>>> " + params);

		params.put("L_ORD_NO", params.get("ordNo"));

		List<EgovMap>  list = membershipQuotationService.quotationList(params);

		model.addAttribute("quotationList",  new Gson().toJson(list));

		return "sales/payPop/payQuotationListPop";
	}

	@RequestMapping(value = "/membershipListPop.do")
	public String membershipListPop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("params ======================================>>> " + params);

		params.put("ORD_NO", params.get("ordNo"));

		List<EgovMap>  list = membershipService.selectMembershipList(params);

		model.addAttribute("membershipList",  new Gson().toJson(list));

		return "sales/payPop/membershipListPop";
	}

	@RequestMapping(value = "/rentalMembershipListPop.do")
	public String rentalMembershipListPop(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("params ======================================>>> " + params);

		params.put("orderNo", params.get("ordNo"));

		List<EgovMap> list = membershipRentalService.selectList(params);

		model.addAttribute("rentalList",  new Gson().toJson(list));

		return "sales/payPop/rentalMembershipListPop";
	}

	@RequestMapping(value = "/transferHistoryListPop.do")
	public String transferHistoryList(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("params ======================================>>> " + params);

		List<EgovMap> list = payPopService.selectTransferHistoryList(params);

		model.addAttribute("transferList",  new Gson().toJson(list));

		return "sales/payPop/transferHistoryListPop";
	}

	@RequestMapping(value = "/viewHPCodyList.do")
	public String viewHPCodyList(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("params ======================================>>> " + params);
		EgovMap orderDetail = new EgovMap();
		orderDetail = payPopService.selectHPCodyList(params);
		model.addAttribute("orderDetail", orderDetail);

		return "sales/payPop/hpCodyListPop";
	}

	@RequestMapping(value = "/viewGroupOrdList.do")
	public String viewGroupOrdList(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("params ======================================>>> " + params);
		model.put("ordNo", params.get("ordNo"));

		return "sales/payPop/groupOrdListPop";
	}

	@RequestMapping(value = "/viewBillScheduleList.do")
	public String viewBillScheduleList(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("params ======================================>>> " + params);
		model.put("ordId", params.get("ordId"));

		return "sales/payPop/billScheduleListPop";
	}
}