/**
 *
 */
package com.coway.trust.web.sales.promotion;

import java.util.ArrayList;
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
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.promotion.PromotionService;
import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/promotion")
public class PromotionController {

	private static Logger logger = LoggerFactory.getLogger(PromotionController.class);

	@Resource(name = "promotionService")
	private PromotionService promotionService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/promotionList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("toDay", toDay);

		return "sales/promotion/promotionList";
	}

	@RequestMapping(value = "/selectPromotionList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] arrPromoAppTypeId   = request.getParameterValues("promoAppTypeId"); //Promotion Application
		String[] arrPromoTypeId   = request.getParameterValues("promoTypeId"); //Promotion Type

		List<String> lPromoAppTypeId = new ArrayList<String>();

		for(String s : arrPromoAppTypeId){

			lPromoAppTypeId.add(s);

			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_REN == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_RENTAL));
			}
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_OUT == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT));
			}
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_INS == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT));
			}
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_OUTPLS == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS));
			}
		}

		String[] arrPromoAppTypeId2 = new String[lPromoAppTypeId.size()];

		for(int i = 0; i < lPromoAppTypeId.size(); i++){
			arrPromoAppTypeId2[i] = lPromoAppTypeId.get(i);
		}

    	params.put("promoDt", CommonUtils.changeFormat(String.valueOf(params.get("promoDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrPromoAppTypeId != null && !CommonUtils.containsEmpty(arrPromoAppTypeId)) params.put("arrPromoAppTypeId", arrPromoAppTypeId2);
		if(arrPromoTypeId != null && !CommonUtils.containsEmpty(arrPromoTypeId)) params.put("arrPromoTypeId", arrPromoTypeId);

		logger.debug("!@##############################################################################");
		logger.debug("!@###### promoAppTypeId : "+params.get("arrPromoAppTypeId"));
		logger.debug("!@###### promoTypeId : "+params.get("arrPromoTypeId"));
		logger.debug("!@###### promoDt : "+params.get("promoDt"));
		logger.debug("!@###### promoStusId : "+params.get("promoStusId"));
		logger.debug("!@###### promoCode : "+params.get("promoCode"));
		logger.debug("!@###### promoDesc : "+params.get("promoDesc"));
		logger.debug("!@##############################################################################");

		List<EgovMap> resultList = promotionService.selectPromotionList(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectPromotionPrdList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionPrdList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> resultList = promotionService.selectPromotionPrdList(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectPromotionPrdWithPriceList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionPrdWithPriceList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> resultList = promotionService.selectPromotionPrdWithPriceList(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectPromotionFreeGiftList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionFreeGiftList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> resultList = promotionService.selectPromotionFreeGiftList(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/updatePromoStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePromoStatus(@RequestBody PromotionVO promotionVO, HttpServletRequest request, Model model, SessionVO sessionVO) {

		promotionService.updatePromoStatus(promotionVO, sessionVO);;

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(messageAccessor.getMessage("sales.promo.msg2"));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/promotionModifyPop.do")
	public String promotionModifyPop(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap promoInfo = promotionService.selectPromotionDetail(params);

		model.addAttribute("promoInfo", promoInfo);

		return "sales/promotion/promotionModifyPop";
	}

	@RequestMapping(value = "/promotionRegisterPop.do")
	public String promotionRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/promotion/promotionRegisterPop";
	}

	@RequestMapping(value = "/promotionProductPop.do")
	public String promotionProductPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("gubun", params.get("gubun"));
		model.put("promoAppTypeId", params.get("promoAppTypeId"));
		model.put("srvPacId", params.get("srvPacId"));
		return "sales/promotion/promotionProductPop";
	}

	@RequestMapping(value = "/registerPromotion.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerPromotion(@RequestBody PromotionVO promotionVO, HttpServletRequest request, Model model, SessionVO sessionVO) {

		promotionService.registerPromoReqst(promotionVO, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage("New promotion request successfully saved.");

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updatePromotion.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePromotion(@RequestBody PromotionVO promotionVO, HttpServletRequest request, Model model, SessionVO sessionVO) {


		ReturnMessage message = new ReturnMessage();

		int cnt = promotionService.cntInPrgrsPromoReqst(promotionVO.getSalesPromoMVO().getPromoId());
		if(cnt < 1) {
			promotionService.updatePromoReqst(promotionVO, sessionVO);
			message.setCode(AppConstants.SUCCESS);
//			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setMessage("Update promotion request saved");
		}
		else {
			message.setCode(AppConstants.FAIL);
			message.setMessage("There are request pending for approval on this promotion");
		}
		// 결과 만들기


		return ResponseEntity.ok(message);
	}

    @RequestMapping(value = "/selectMembershipPkg.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectMembershipPkg(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> resultList = promotionService.selectMembershipPkg(params);
    	return ResponseEntity.ok(resultList);
    }

    @RequestMapping(value = "/selectProductCodeList.do", method = RequestMethod.POST)
    public ResponseEntity<List<EgovMap>> selectProductCodeList(@RequestBody Map<String, Object> params)
    {
    	List<EgovMap> resultList = promotionService.selectProductCodeList(params);
    	return ResponseEntity.ok(resultList);
    }

    @RequestMapping(value = "/selectFreeGiftCodeList.do", method = RequestMethod.POST)
    public ResponseEntity<List<EgovMap>> selectFreeGiftCodeList(@RequestBody Map<String, Object> params)
    {
    	List<EgovMap> resultList = promotionService.selectFreeGiftCodeList(params);
    	return ResponseEntity.ok(resultList);
    }

	@RequestMapping(value = "/selectPriceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<List<SalesPromoDVO>> selectPriceInfo(@RequestBody PromotionVO promotionVO) {

		List<SalesPromoDVO> resultList = promotionService.selectPriceInfo(promotionVO);

		return ResponseEntity.ok(resultList);
	}

    @RequestMapping(value = "/selectProductCategoryList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectProductCategoryList(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> resultList = promotionService.selectProductCategoryList();
    	return ResponseEntity.ok(resultList);
    }

	@RequestMapping(value = "/promotionApprovalList.do")
	public String promotionApprovalList(@RequestParam Map<String, Object> params, ModelMap model) {
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("toDay", toDay);

		return "sales/promotion/promotionApprovalList";
	}

	@RequestMapping(value = "/selectPromotionApprovalList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionApprovalList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		String[] arrPromoAppTypeId   = request.getParameterValues("promoAppTypeId"); //Promotion Application
		String[] arrPromoTypeId   = request.getParameterValues("promoTypeId"); //Promotion Type

		List<String> lPromoAppTypeId = new ArrayList<String>();

		int roleId;
		if (sessionVO == null) {
			roleId = 99999999;
		} else {
			roleId = sessionVO.getRoleId();
		}

    	params.put("roleId", roleId);


		for(String s : arrPromoAppTypeId){

			lPromoAppTypeId.add(s);

			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_REN == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_RENTAL));
			}
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_OUT == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT));
			}
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_INS == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT));
			}
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_OUTPLS == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS));
			}
		}

		String[] arrPromoAppTypeId2 = new String[lPromoAppTypeId.size()];

		for(int i = 0; i < lPromoAppTypeId.size(); i++){
			arrPromoAppTypeId2[i] = lPromoAppTypeId.get(i);
		}

    	params.put("promoDt", CommonUtils.changeFormat(String.valueOf(params.get("promoDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrPromoAppTypeId != null && !CommonUtils.containsEmpty(arrPromoAppTypeId)) params.put("arrPromoAppTypeId", arrPromoAppTypeId2);
		if(arrPromoTypeId != null && !CommonUtils.containsEmpty(arrPromoTypeId)) params.put("arrPromoTypeId", arrPromoTypeId);

		logger.debug("!@##############################################################################");
		logger.debug("!@###### promoAppTypeId : "+params.get("arrPromoAppTypeId"));
		logger.debug("!@###### promoTypeId : "+params.get("arrPromoTypeId"));
		logger.debug("!@###### promoDt : "+params.get("promoDt"));
		logger.debug("!@###### promoStusId : "+params.get("promoStusId"));
		logger.debug("!@###### promoDesc : "+params.get("promoDesc"));
		logger.debug("!@###### roleId : "+params.get("roleId"));
		logger.debug("!@##############################################################################");

		List<EgovMap> resultList = promotionService.selectPromotionApprovalList(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectPromoReqstInfo.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectPromoReqstInfo(@RequestParam Map<String, Object>params, ModelMap model) {

		EgovMap result = promotionService.selectPromoReqstInfo(params);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectPromoReqstPrdList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromoReqstPrdList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> resultList = promotionService.selectPromoReqstPrdList(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/registerNewPromo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerNewPromo(@RequestBody PromotionVO promotionVO, HttpServletRequest request, Model model, SessionVO sessionVO) {

		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}


		Map<String, Object> map = new HashMap();
		map.put("upd_user", loginId);
		map.put("reqstId", promotionVO.getSalesPromoMVO().getPromoReqstId());
		map.put("appvStus", promotionVO.getSalesPromoMVO().getAppvStus());
		map.put("appvRemark", promotionVO.getSalesPromoMVO().getAppvRemark());

		promotionService.updatePromoReqstApproval(map);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		if(promotionVO.getSalesPromoMVO().getAppvStus() == 5){
			promotionService.registerPromotion(promotionVO, sessionVO);
			message.setMessage("Promo request has been successfully approved");
		}

		else{
			message.setMessage("Promo request has been successfully rejected");
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updatePromoInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePromoInfo(@RequestBody PromotionVO promotionVO, HttpServletRequest request, Model model, SessionVO sessionVO) {

		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}


		Map<String, Object> map = new HashMap();
		map.put("upd_user", loginId);
		map.put("reqstId", promotionVO.getSalesPromoMVO().getPromoReqstId());
		map.put("appvStus", promotionVO.getSalesPromoMVO().getAppvStus());
		map.put("appvRemark", promotionVO.getSalesPromoMVO().getAppvRemark());

		promotionService.updatePromoReqstApproval(map);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		if(promotionVO.getSalesPromoMVO().getAppvStus() == 5){
			promotionService.updatePromotion(promotionVO, sessionVO);
			message.setMessage("Promo request has been successfully approved");
		}

		else{
			message.setMessage("Promo request has been successfully rejected");
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectPromoHistList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromoHistList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> resultList = promotionService.selectPromoHistList(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectPromoReqstPrdHistList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromoReqstPrdHistList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> resultList = promotionService.selectPromoReqstPrdHistList(params);

		return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectExcelPromoList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectExcelPromoList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] arrPromoAppTypeId   = request.getParameterValues("promoAppTypeId"); //Promotion Application
		String[] arrPromoTypeId   = request.getParameterValues("promoTypeId"); //Promotion Type

		List<String> lPromoAppTypeId = new ArrayList<String>();

		for(String s : arrPromoAppTypeId){

			lPromoAppTypeId.add(s);

			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_REN == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_RENTAL));
			}
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_OUT == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT));
			}
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_INS == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT));
			}
			if(SalesConstants.PROMO_APP_TYPE_CODE_ID_OUTPLS == Integer.parseInt(s)) {
				lPromoAppTypeId.add(String.valueOf(SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS));
			}
		}

		String[] arrPromoAppTypeId2 = new String[lPromoAppTypeId.size()];

		for(int i = 0; i < lPromoAppTypeId.size(); i++){
			arrPromoAppTypeId2[i] = lPromoAppTypeId.get(i);
		}

    	params.put("promoDt", CommonUtils.changeFormat(String.valueOf(params.get("promoDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrPromoAppTypeId != null && !CommonUtils.containsEmpty(arrPromoAppTypeId)) params.put("arrPromoAppTypeId", arrPromoAppTypeId2);
		if(arrPromoTypeId != null && !CommonUtils.containsEmpty(arrPromoTypeId)) params.put("arrPromoTypeId", arrPromoTypeId);

		logger.debug("!@##############################################################################");
		logger.debug("!@###### promoAppTypeId : "+params.get("arrPromoAppTypeId"));
		logger.debug("!@###### promoTypeId : "+params.get("arrPromoTypeId"));
		logger.debug("!@###### promoDt : "+params.get("promoDt"));
		logger.debug("!@###### promoStusId : "+params.get("promoStusId"));
		logger.debug("!@###### promoCode : "+params.get("promoCode"));
		logger.debug("!@###### promoDesc : "+params.get("promoDesc"));
		logger.debug("!@##############################################################################");

		List<EgovMap> resultList = promotionService.selectExcelPromoList(params);

		return ResponseEntity.ok(resultList);
	}



}
