/**
 * 
 */
package com.coway.trust.web.sales.promotion;

import java.text.ParseException;
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
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.promotion.PromotionListService;
import com.coway.trust.biz.sales.promotion.PromotionRegisterService;
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
public class PromotionRegisterController {

	private static Logger logger = LoggerFactory.getLogger(PromotionRegisterController.class);
	
	@Resource(name = "promotionRegisterService")
	private PromotionRegisterService promotionRegisterService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@RequestMapping(value = "/promotionRegisterPop.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/promotion/promotionRegisterPop";
	}
	
	@RequestMapping(value = "/promotionProductPop.do")
	public String promotionProductPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("gubun", params.get("gubun"));
		return "sales/promotion/promotionProductPop";
	}
	
	@RequestMapping(value = "/registerPromotion.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerOrder(@RequestBody PromotionVO promotionVO, HttpServletRequest request, Model model, SessionVO sessionVO) {
		
		promotionRegisterService.registerPromotion(promotionVO, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage(messageAccessor.getMessage("New promotion successfully saved."));

		return ResponseEntity.ok(message);
	}
	
    @RequestMapping(value = "/selectMembershipPkg.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectMembershipPkg(@RequestParam Map<String, Object> params)
    {
    	List<EgovMap> resultList = promotionRegisterService.selectMembershipPkg(params);
    	return ResponseEntity.ok(resultList);
    }
    
	@RequestMapping(value = "/selectPriceInfo.do", method = RequestMethod.POST)
	public ResponseEntity<List<SalesPromoDVO>> selectPriceInfo(@RequestBody PromotionVO promotionVO) {
		
		List<SalesPromoDVO> resultList = promotionRegisterService.selectPriceInfo(promotionVO);

		return ResponseEntity.ok(resultList);
	}
}
