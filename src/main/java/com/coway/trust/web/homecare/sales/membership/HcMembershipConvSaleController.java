/**
 *
 */
package com.coway.trust.web.homecare.sales.membership;

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
import com.coway.trust.biz.sales.mambership.MembershipConvSaleService;
import com.coway.trust.biz.sales.mambership.MembershipService;
import com.coway.trust.biz.sales.mambership.impl.MembershipMapper;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;



/**
 *
 * @author hamhg
 *
 */
@Controller
@RequestMapping(value = "/homecare/sales/membership")
public class  HcMembershipConvSaleController {

	private static Logger logger = LoggerFactory.getLogger(HcMembershipConvSaleController.class);

	@Resource(name = "membershipConvSaleService")
	private MembershipConvSaleService membershipConvSaleService;

	@Resource(name = "membershipService")
	private MembershipService membershipService;


	@RequestMapping(value = "/mConvSale.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("in  mConvSale.do ");

		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		model.addAttribute("ORD_ID",params.get("ORD_ID"));
		model.addAttribute("QUOT_ID",params.get("QUOT_ID"));
		model.addAttribute("MBRSH_ID",params.get("MBRSH_ID"));

		return "homecare/sales/membership/hcmQuotConvSalePop";
	}

//	@RequestMapping(value = "/mAutoConvSale.do")
//	public String mAutoConvSale(@RequestParam Map<String, Object> params, ModelMap model) {
//
//		logger.debug("in  mAutoConvSale.do ");
//
//		logger.debug("			pram set  log");
//		logger.debug("					" + params.toString());
//		logger.debug("			pram set end  ");
//
//		List<EgovMap> list = membershipService.selectMembershipQuotInfo(params);
//
//
//		logger.debug("===>"+list.toString());
//
//		model.addAttribute("ORD_ID",((EgovMap)list.get(0)).get("ordId"));
//		model.addAttribute("QUOT_ID",params.get("QUOT_ID"));
//		logger.debug("=ordId==>"+((EgovMap)list.get(0)).get("ordId"));
//		logger.debug("QUOT_ID {}",params.get("QUOT_ID"));
//
//		return "sales/membership/mQuotConvSalePop";
//	}
//
//	@RequestMapping(value = "/mQuotConvSaleSave.do", method = RequestMethod.POST)
//	public ResponseEntity<ReturnMessage> mQuotConvSaleSave(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
//
//		logger.debug("in  mQuotConvSaleSave ");
//		logger.debug("			pram set  log");
//		logger.debug("					" + params.toString());
//		logger.debug("			pram set end  ");
//
//		params.put("updator", sessionVO.getUserId());
//		params.put("userId", sessionVO.getUserId());
//
//		// check ref_no duplication
//		if (membershipConvSaleService.checkDuplicateRefNo(params)){
//			ReturnMessage message = new ReturnMessage();
//			message.setCode(AppConstants.FAIL);
//			message.setMessage("Entered SVM No. had been used. Please try other SVM No.");
//
//			return ResponseEntity.ok(message);
//		}
//
//		ReturnMessage message = new ReturnMessage();
//
//		EgovMap  hasbillMap =membershipConvSaleService.getHasBill(params);
//
//
//
//		if(null !=hasbillMap){
//
//			 if(! CommonUtils.isEmpty(hasbillMap.get("srvMemLgId"))){
//					message.setCode(AppConstants.FAIL);
//					message.setData("hasBill");
//				 	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
//					return ResponseEntity.ok(message);
//			 }
//		}
//
//		//int rtnValue = membershipConvSaleService.SAL0095D_insert(params);
//		String docNo =  membershipConvSaleService.SAL0095D_insert(params);
//
//		 //update e-voucher temp table
//		membershipConvSaleService.updateEligibleEVoucher(params);
//		 //
//
//		message.setCode(AppConstants.SUCCESS);
//		message.setData(docNo);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
//
//
//		return ResponseEntity.ok(message);
//
//	}
//
//	@RequestMapping(value = "/getHasBill.do" ,method = RequestMethod.GET)
//	public ResponseEntity<EgovMap>  getHasBill(@RequestParam Map<String, Object> params, HttpServletRequest request,Model model)	throws Exception {
//
//		logger.debug("in  getHasBill ");
//		logger.debug("			pram set  log");
//		logger.debug("					" + params.toString());
//		logger.debug("			pram set end  ");
//
//		EgovMap  hasbillMap =membershipConvSaleService.getHasBill(params);
//
//		return ResponseEntity.ok(hasbillMap);
//	}

	@Autowired
	private MessageSourceAccessor messageAccessor;


}
