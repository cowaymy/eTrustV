/**
 *
 */
package com.coway.trust.web.sales.mambership;

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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.mambership.MembershipRentalChannelService;
import com.coway.trust.biz.sales.mambership.MembershipRentalService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.sales.customer.CustomerForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;



/**
 *
 * @author hamhg
 *
 */
@Controller
@RequestMapping(value = "/sales/membershipRentalChannel")
public class  MembershipRentalPayChannelController {

	private static Logger logger = LoggerFactory.getLogger(MembershipRentalPayChannelController.class);

	@Resource(name = "membershipRentalChannelService")
	private MembershipRentalChannelService  membershipRentalChannelService;


	@Resource(name = "membershipRentalService")
	private MembershipRentalService  membershipRentalService;

	@Resource(name = "customerService")
	private CustomerService customerService;




	@RequestMapping(value = "/membershipRentalChannelPop.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  membershipRentalChannelPop.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


		model.addAttribute("srvCntrctId",params.get("srvCntrctId"));
		model.addAttribute("srvCntrctOrdId",params.get("srvCntrctOrdId"));
		model.addAttribute("custId",params.get("custId"));

		return "sales/membership/membershipRentalChannelPop";
	}



	@RequestMapping(value = "/selectPatsetInfo", method = RequestMethod.GET)
	public ResponseEntity<Map>  selectPatsetInfo(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sesseionVO) throws Exception {

		logger.debug("in  selectPatsetInfo ");

		EgovMap paysetInfo = null;
		EgovMap custBasicinfo = null;


		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");


		paysetInfo =  membershipRentalService.selectPatsetInfo(params, sesseionVO);
		params.put("custId", paysetInfo.get("custId"));
		custBasicinfo =  customerService.selectCustomerViewBasicInfo(params);

		Map<String, Object> map = new HashMap();
		map.put("paysetInfo", paysetInfo);
		map.put("custBasicinfo", custBasicinfo);

		return ResponseEntity.ok(map);

	}



	@RequestMapping(value = "/getLoadRejectReasonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getLoadRejectReasonList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {

		logger.debug("in  getLoadRejectReasonList ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = membershipRentalChannelService.getLoadRejectReasonList(params);


		return ResponseEntity.ok(list);
	}



	@RequestMapping(value = "/insertRentalChannel.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertRentalChannel(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		logger.debug("in  insertRentalChannel ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		params.put("updator", sessionVO.getUserId());

		int  o = membershipRentalChannelService.SAL0074D_update(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(o);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


		return ResponseEntity.ok(message);

	}



	@Autowired
	private MessageSourceAccessor messageAccessor;


}
