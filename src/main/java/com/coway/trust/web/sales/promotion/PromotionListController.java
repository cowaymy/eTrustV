/**
 * 
 */
package com.coway.trust.web.sales.promotion;

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
import com.coway.trust.biz.sales.promotion.PromotionListService;
import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
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
public class PromotionListController {

	private static Logger logger = LoggerFactory.getLogger(PromotionListController.class);
	
	@Resource(name = "promotionListService")
	private PromotionListService promotionListService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@RequestMapping(value = "/promotionList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/promotion/promotionList";
	}
	
	@RequestMapping(value = "/selectPromotionList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		String[] arrPromoAppTypeId   = request.getParameterValues("promoAppTypeId"); //Promotion Application
		String[] arrPromoTypeId   = request.getParameterValues("promoTypeId"); //Promotion Type
    	
    	params.put("promoDt", CommonUtils.changeFormat(String.valueOf(params.get("promoDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	
		if(arrPromoAppTypeId != null && !CommonUtils.containsEmpty(arrPromoAppTypeId)) params.put("arrPromoAppTypeId", arrPromoAppTypeId);
		if(arrPromoTypeId != null && !CommonUtils.containsEmpty(arrPromoTypeId)) params.put("arrPromoTypeId", arrPromoTypeId);

		logger.debug("!@##############################################################################");
		logger.debug("!@###### promoAppTypeId : "+params.get("arrPromoAppTypeId"));
		logger.debug("!@###### promoTypeId : "+params.get("arrPromoTypeId"));
		logger.debug("!@###### promoDt : "+params.get("promoDt"));
		logger.debug("!@###### promoStusId : "+params.get("promoStusId"));
		logger.debug("!@###### promoCode : "+params.get("promoCode"));
		logger.debug("!@###### promoDesc : "+params.get("promoDesc"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> resultList = promotionListService.selectPromotionList(params);

		return ResponseEntity.ok(resultList);
	}
	
	@RequestMapping(value = "/updatePromoStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerOrder(@RequestBody PromotionVO promotionVO, HttpServletRequest request, Model model, SessionVO sessionVO) {
		
		promotionListService.updatePromoStatus(promotionVO, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(messageAccessor.getMessage("Promotion status successfully saved."));

		return ResponseEntity.ok(message);
	}
}
