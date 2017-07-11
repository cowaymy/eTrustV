/**
 * 
 */
package com.coway.trust.web.sales.pst;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.pst.PSTRequestDOService;
import com.coway.trust.biz.sales.pst.PSTRequestDOVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/pst")
public class PSTRequestDOController {

	private static final Logger logger = LoggerFactory.getLogger(PSTRequestDOController.class);
	
	@Resource(name = "pstRequestDOService")
	private PSTRequestDOService pstRequestDOService;
	
	/**
	 * 화면 호출. - 데이터 포함 호출.
	 */
	@RequestMapping(value = "/selectPstRequestDOList.do")
	public String selectPstRequestDOList(@ModelAttribute("pstRequestVO") PSTRequestDOVO pstRequestVO,
			@RequestParam Map<String, Object>params, ModelMap model) {
		
		List<EgovMap> pstList = pstRequestDOService.selectPstRequestDOList(params);
		model.addAttribute("pstList", pstList);
		
		return "sales/pst/pstRequestDoList";
	}
	
	
	/**
	 * 화면 호출. - PST Info
	 */
	@RequestMapping(value = "/getPstRequestDODetailPop.do")
	public String getPstRequestDODetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		params.put("pstSalesOrdId", "129");			// 임시
		
		EgovMap pstInfo = pstRequestDOService.getPstRequestDODetailPop(params);
		model.addAttribute("pstInfo", pstInfo);
		
		return "sales/pst/pstRequestDoDetailPop";
	}
	
	
	/**
	 * 화면 호출. -PST Stock List (초기화면)
	 */
	@RequestMapping(value = "/getPstRequestDOStockDetailPop.do")
	public String getPstRequestDOStockDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		params.put("pstSalesOrdId", "129");			// 임시
		
		params.get("pstSalesOrdId");

		model.addAttribute("pstSalesOrdId", params.get("pstSalesOrdId"));
		
		return "sales/pst/pstRequestDoStockDetailPop";
	}
	
	
	/**
	 * 화면 호출. -PST Stock List (데이터조회)
	 */
	@RequestMapping(value = "/getPstStockJsonDetailPop", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getPstStockJsonDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> pstStockList = pstRequestDOService.getPstRequestDOStockDetailPop(params);

		// 데이터 리턴.
		return ResponseEntity.ok(pstStockList);
	}
	
}
