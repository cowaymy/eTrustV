/**
 *
 */
package com.coway.trust.web.sales.promotion;

import java.util.ArrayList;
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
import com.coway.trust.biz.sales.promotion.ProductMgmtService;
import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/productMgmt/")
public class ProductMgmtController {

	private static Logger logger = LoggerFactory.getLogger(ProductMgmtController.class);

	@Resource(name = "productMgmtService")
	private ProductMgmtService productMgmtService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/productMgmtList.do")
	public String productMgmtList(@RequestParam Map<String, Object> params) {
		return "sales/promotion/productMgmtList";
	}

	@RequestMapping(value = "/selectProductMgmtList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPromotionList(@RequestParam Map<String, Object>params) {
    List<EgovMap> resultList = productMgmtService.selectProductMgmtList(params);
    return ResponseEntity.ok(resultList);
  }

	@RequestMapping(value = "/selectPromotionListByStkId.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionListByStkId(@RequestParam Map<String, Object>params) {
	  List<EgovMap> resultList = productMgmtService.selectPromotionListByStkId(params);
	  return ResponseEntity.ok(resultList);
	}

	@RequestMapping(value = "/selectProductDiscontinued.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectProductDiscontinued(@RequestParam Map<String, Object>params) {
    EgovMap resultList = productMgmtService.selectProductDiscontinued(params);
    return ResponseEntity.ok(resultList);
  }

	@RequestMapping(value = "/productMgmtModifyPop.do")
	public String productMgmtModifyPop(@RequestParam Map<String, Object> params, Model model) {
	  EgovMap resultList = (EgovMap) productMgmtService.selectProductMgmtList(params).get(0);
	  model.addAttribute("productCtrlData",resultList);

	  return "sales/promotion/productMgmtModifyPop";
	}

	@RequestMapping(value = "/selectAdminKeyinCount.do")
  public ResponseEntity<EgovMap> selectAdminKeyinCount(@RequestParam Map<String, Object> params,HttpServletRequest request) {
	  String[] adminKeyinStus = request.getParameterValues("quota_admin_stus");

	  if(!CommonUtils.containsEmpty(adminKeyinStus)) params.put("adminKeyinStus", adminKeyinStus);

	  EgovMap resultList = productMgmtService.selectAdminKeyinCount(params);
    return ResponseEntity.ok(resultList);
  }

	@RequestMapping(value = "/selecteKeyinCount.do")
  public ResponseEntity<EgovMap> selecteKeyinCount(@RequestParam Map<String, Object> params,HttpServletRequest request) {
	  String[] ekeyinStus = request.getParameterValues("quota_ekeyin_stus");

	  if(!CommonUtils.containsEmpty(ekeyinStus)) params.put("ekeyinStus", ekeyinStus);

	  EgovMap resultList = productMgmtService.selecteKeyinCount(params);
	  return ResponseEntity.ok(resultList);
  }

	@RequestMapping(value = "/selectQuotaCount.do")
  public ResponseEntity<EgovMap> selectQuotaCount(@RequestParam Map<String, Object> params) {

    EgovMap resultList = productMgmtService.selectQuotaCount(params);

    return ResponseEntity.ok(resultList);
  }


	@RequestMapping(value = "/updateProductCtrl.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateProductCtrl(@RequestBody Map<String, Object> params, SessionVO sessionVO) {

    params.put("userId",sessionVO.getUserId());
    productMgmtService.updateProductCtrl(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage("sales.promo.msg2"));

    return ResponseEntity.ok(message);
  }

}
