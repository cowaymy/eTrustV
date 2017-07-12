/**
 * 
 */
package com.coway.trust.web.sales.pst;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.pst.PSTRequestDOService;
import com.coway.trust.biz.sales.pst.PSTRequestDOVO;
import com.coway.trust.biz.sales.pst.PSTSalesDVO;
import com.coway.trust.biz.sales.pst.PSTSalesMVO;
import com.coway.trust.biz.sample.TestVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;

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
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/**
	 * 화면 호출. - PST Info
	 */
	@RequestMapping(value = "/getPstRequestDOEditPop.do")
	public String getPstRequestDOEditPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		params.put("pstSalesOrdId", "128");			// 임시
		
		EgovMap pstInfo = pstRequestDOService.getPstRequestDODetailPop(params);
		model.addAttribute("pstInfo", pstInfo);
		
		return "sales/pst/pstRequestDoEditPop";
	}
	
	
	/**
	 * 화면 호출. -PST Stock List (초기화면)
	 */
	@RequestMapping(value = "/getPstRequestDOStockEditPop.do")
	public String getPstRequestDOStockEditPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		params.put("pstSalesOrdId", "128");			// 임시
		params.put("pstRefNo", "PSO0000128");			// 임시
		
		params.get("pstSalesOrdId");
		params.get("pstRefNo");

		model.addAttribute("pstSalesOrdId", params.get("pstSalesOrdId"));
		model.addAttribute("pstRefNo", params.get("pstRefNo"));
		
		return "sales/pst/pstRequestDoStockEditPop";
	}
	
	/**
	 * VO 을 이용한 Grid 편집 데이터 저장/수정/삭제 데이터 처리 샘플.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateStockList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateStockList(@RequestBody PSTRequestDOForm pstRequestDOForm,
			Model model) {

		GridDataSet<PSTStockListGridForm> dataSet = pstRequestDOForm.getDataSet();
		List<PSTStockListGridForm> updateList = dataSet.getUpdate(); // 수정 리스트 얻기
		List<PSTStockListGridForm> addList    = dataSet.getAdd();    // 추가 리스트 얻기
		List<PSTStockListGridForm> removeList = dataSet.getRemove(); // 제거 리스트 얻기
				
		PSTSalesMVO pstSalesMVO = pstRequestDOForm.getPstSalesMVO();

		logger.info("##### PSTRequestDOController.updateStockList START #####");
		logger.info("pstSalesMVO.getPstSalesOrdId() : " + pstSalesMVO.getPstSalesOrdId());
		//logger.info("pstSalesMVO.getSsID() : ", pstSalesMVO.getSsID());
		
		List<PSTSalesDVO> pstSalesDVOList = new ArrayList<>();
		//PSTSalesDVO pstSalesDVO = null;
		
		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		updateList.forEach(form -> {
//			logger.debug(" add id : {}", form.getId());
//			logger.debug(" add name : {}", form.getName());
//			logger.debug(" add date : {}", form.getDate());
			
			PSTSalesDVO pstSalesDVO = new PSTSalesDVO();
			
			pstSalesDVO.setPstItmId(form.getPstItmId());
			pstSalesDVO.setPstSalesOrdId(form.getPstSalesOrdId());
			pstSalesDVO.setPstItmStkId(form.getPstItmStkId());
			pstSalesDVO.setPstItmPrc(form.getPstItmPrc());
			pstSalesDVO.setPstItmReqQty(form.getPstItmReqQty());
			pstSalesDVO.setPstItmTotPrc(form.getPstItmTotPrc());
			pstSalesDVO.setPstItmDoQty(form.getPstItmDoQty());
			pstSalesDVO.setPstItmCanQty(form.getPstItmCanQty());
			pstSalesDVO.setPstItmCanQty2(form.getPstItmCanQty2());
			pstSalesDVO.setPstItmBalQty(form.getPstItmBalQty());
			
			pstSalesDVOList.add(pstSalesDVO);
		});

		// 콘솔로 찍어보기
		logger.info("수정 : {}", updateList.toString());
		logger.info("추가 : {}", addList.toString());
		logger.info("삭제 : {}", removeList.toString());
		
		pstRequestDOService.updateStock(pstSalesDVOList, pstSalesMVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
