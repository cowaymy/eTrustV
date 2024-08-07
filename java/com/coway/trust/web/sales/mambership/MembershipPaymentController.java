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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.mambership.MembershipPaymentService;
import egovframework.rte.psl.dataaccess.util.EgovMap;



/**
 * 
 * @author hamhy
 *
 */
@Controller
@RequestMapping(value = "/sales/membership")
public class  MembershipPaymentController {

	private static Logger logger = LoggerFactory.getLogger(MembershipPaymentController.class);
	
	@Resource(name = "membershipPaymentService")
	private MembershipPaymentService membershipPaymentService;     
	
	@RequestMapping(value = "/membershipPayment.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  membershipPayment.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		model.addAttribute("PAY_MBRSH_ID", params.get("MBRSH_ID"));
		model.addAttribute("PAY_ORD_ID", params.get("ORD_ID"));
		return "sales/membership/paymentPop";
	}
	
	
	@RequestMapping(value = "/paymentConfig" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  PaymentConfig(@RequestParam Map<String, Object> params, Model model)	throws Exception {

		logger.debug("in  PaymentConfig ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  srvconfig = membershipPaymentService.selPaymentConfig(params);
		
		return ResponseEntity.ok(srvconfig);
	}
	
	
	
	@RequestMapping(value = "/paymentLastMembership" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  paymentLastMembership(@RequestParam Map<String, Object> params, Model model)	throws Exception {

		logger.debug("in  paymentLastMembership ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  srvconfig = membershipPaymentService.paymentLastMembership(params);
		
		return ResponseEntity.ok(srvconfig);
	}
	
	

	
	@RequestMapping(value = "/paymentInsAddress" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  paymentInsAddress(@RequestParam Map<String, Object> params, Model model)	throws Exception {

		logger.debug("in  paymentLastMembership ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  srvconfig = membershipPaymentService.paymentInsAddress(params);
		
		return ResponseEntity.ok(srvconfig);
	}
	
	
	


	@RequestMapping(value = "/paymentCharges", method = RequestMethod.GET)
	public ResponseEntity<Map> paymentCharges(@RequestParam Map<String, Object> params, ModelMap model,
			HttpServletRequest request) {

		EgovMap item = new EgovMap();

		membershipPaymentService.paymentCharges(params);

		logger.debug("v_result : {}", params.get("p1"));

		Map<String, Object> map = new HashMap();
		map.put("chargesInfo", params.get("p1"));

		return ResponseEntity.ok(map);
	}
	
	
	
	

	@RequestMapping(value = "/paymentAddNewTR.do")
	public String paymentAddNewTR(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  paymentAddNewTR.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		return "sales/membership/paymentAddNewTRPop";
	}
	
	
	
	@RequestMapping(value = "/paymentCollecter.do")
	public String paymentCollecter(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  paymentCollecter.do ");  

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		model.addAttribute("resultFun", params.get("resultFun"));
		
		return "sales/membership/paymentCollecterPop";
	}
	
	
	
	

	@RequestMapping(value = "/paymentCollecterList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  paymentCollecterList(@RequestParam Map<String, Object> params, Model model)	throws Exception {

		logger.debug("in  paymentCollecterList ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipPaymentService.paymentCollecterList(params);
		
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/paymentColleConfirm" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  paymentColleConfirm(@RequestParam Map<String, Object> params, Model model)	throws Exception {

		logger.debug("in  paymentCollecterList ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		List<EgovMap>  list = membershipPaymentService.paymentColleConfirm(params);
		
		return ResponseEntity.ok(list);
	}
	
	
	
	@RequestMapping(value = "/paymentGetAccountCode" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  paymentGetAccountCode(@RequestParam Map<String, Object> params, Model model)	throws Exception {

		
		params.put("CODE_TYPE", params.get("groupCode"));
		logger.debug("in  paymentCollecterList ");  
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");
		
		
		
		List<EgovMap>  list = membershipPaymentService.paymentGetAccountCode(params);
		
		return ResponseEntity.ok(list);
	}
	
	
	
	
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	
}
