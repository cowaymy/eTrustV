/**
 * 
 */
package com.coway.trust.web.sales.pst;

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
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

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
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
		
	/**
	 * 화면 호출. - 데이터 포함 호출.
	 */
	@RequestMapping(value = "/selectPstRequestDOList.do")
	public String selectPstRequestDOList(@ModelAttribute("pstRequestVO") PSTRequestDOVO pstRequestVO,
			@RequestParam Map<String, Object>params, ModelMap model) {
		
//		List<EgovMap> pstList = pstRequestDOService.selectPstRequestDOList(params);
//		model.addAttribute("pstList", pstList);
		
		return "sales/pst/pstRequestDoList";
	}
	
	
	/**
	 * 화면 호출. -PST Request Do List (데이터조회)
	 */
	@RequestMapping(value = "/selectPstRequestDOJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPstRequestDOJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> pstList = null;
		
		String[] pstStusList = request.getParameterValues("pstStusId");
		params.put("pstStusList", pstStusList);
		
		if(params != null && !"".equals(params.toString().trim())){
			String stDate = (String)params.get("createStDate");
			if(stDate != null && stDate != ""){
				String createStDate = stDate.substring(6) + "-" + stDate.substring(3, 5) + "-" + stDate.substring(0, 2);
				params.put("createStDate", createStDate);
			}
			String enDate = (String)params.get("createEnDate");
			if(enDate != null && enDate != ""){
				String createEnDate = enDate.substring(6) + "-" + enDate.substring(3, 5) + "-" + enDate.substring(0, 2);
				params.put("createEnDate", createEnDate);
			}
			pstList = pstRequestDOService.selectPstRequestDOList(params);
		}

		// 데이터 리턴.
		return ResponseEntity.ok(pstList);
	}
	
	
	/**
	 * 화면 호출. - PST Info
	 */
	@RequestMapping(value = "/getPstRequestDODetailPop.do")
	public String getPstRequestDODetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		EgovMap pstInfo = pstRequestDOService.pstRequestDOInfo(params);
		EgovMap pstMailContact = pstRequestDOService.pstRequestDOMailContact(params);
		EgovMap pstDeliveryContact = pstRequestDOService.pstRequestDODelvryContact(params);
		EgovMap pstMailAddr = pstRequestDOService.pstRequestDOMailAddress(params);
		EgovMap pstDeliveryAddr = pstRequestDOService.pstRequestDODelvryAddress(params);
		
		logger.info("##### EDIT pstSalesOrdIdParam #####" +params.get("pstSalesOrdIdParam"));
		logger.info("##### EDIT pstDealerDelvryCntId #####" +params.get("pstDealerDelvryCntId"));
		logger.info("##### EDIT pstDealerMailCntId #####" +params.get("pstDealerMailCntId"));
		logger.info("##### EDIT pstDealerDelvryCntId #####" +params.get("pstDealerDelvryAddId"));
		logger.info("##### EDIT pstDealerMailCntId #####" +params.get("pstDealerMailAddId"));
		
		// Detail Popup Tab
		model.addAttribute("pstInfo", pstInfo);
		model.addAttribute("pstMailAddr", pstMailAddr);
		model.addAttribute("pstDeliveryAddr", pstDeliveryAddr);
		model.addAttribute("pstMailContact", pstMailContact);
		model.addAttribute("pstDeliveryContact", pstDeliveryContact);
		
		// parameter
		model.addAttribute("pstStusIdParam", params.get("pstStusIdParam"));
		
		// Edit Popup parameter
		model.addAttribute("pstSalesOrdIdParam", params.get("pstSalesOrdIdParam"));
		model.addAttribute("pstDealerDelvryCntId", params.get("pstDealerDelvryCntId"));
		model.addAttribute("pstDealerMailCntId", params.get("pstDealerMailCntId"));
		model.addAttribute("pstDealerDelvryAddId", params.get("pstDealerDelvryAddId"));
		model.addAttribute("pstDealerMailAddId", params.get("pstDealerMailAddId"));
		
		return "sales/pst/pstRequestDoDetailPop";
	}
	
	
	/**
	 * 화면 호출. -PST Request Do List (데이터조회)
	 */
	@RequestMapping(value = "/getInchargeList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getInchargeList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> cmbPstInchargeList = pstRequestDOService.cmbPstInchargeList();

		// 데이터 리턴.
		return ResponseEntity.ok(cmbPstInchargeList);
	}
	
	
	/**
	 * 화면 호출. -PST Stock List (초기화면)
	 
	@RequestMapping(value = "/getPstRequestDOStockDetailPop.do")
	public String getPstRequestDOStockDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
//		params.put("pstSalesOrdId", "129");			// 임시
		
		params.get("pstSalesOrdId");

		model.addAttribute("pstSalesOrdId", params.get("pstSalesOrdId"));
		
		return "sales/pst/pstRequestDoStockDetailPop";
	}
	*/
	
	/**
	 * 화면 호출. -PST Stock List (데이터조회)
	 */
	@RequestMapping(value = "/getPstStockJsonDetailPop", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getPstStockJsonDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		logger.info("##### Edit Stock Param #####" +params.get("pstSalesOrdId"));
		List<EgovMap> pstEditStockList = pstRequestDOService.pstRequestDOStockList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(pstEditStockList);
	}
	
	
	/**
	 * 화면 호출. - PST Info
	 */
	@RequestMapping(value = "/getPstRequestDOEditPop.do")
	public String getPstRequestDOEditPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		EgovMap pstInfo = pstRequestDOService.pstRequestDOInfo(params);
		EgovMap pstMailContact = pstRequestDOService.pstRequestDOMailContact(params);
		EgovMap pstDeliveryContact = pstRequestDOService.pstRequestDODelvryContact(params);
		EgovMap pstMailAddr = pstRequestDOService.pstRequestDOMailAddress(params);
		EgovMap pstDeliveryAddr = pstRequestDOService.pstRequestDODelvryAddress(params);
		logger.info("##### pstMailContact #####" +pstMailContact.toString());
		logger.info("##### pstDeliveryContact #####" +pstDeliveryContact.toString());
		model.addAttribute("pstInfo", pstInfo);
		model.addAttribute("pstMailAddr", pstMailAddr);
		model.addAttribute("pstDeliveryAddr", pstDeliveryAddr);
		model.addAttribute("pstMailContact", pstMailContact);
		model.addAttribute("pstDeliveryContact", pstDeliveryContact);
		
		// Edit Popup parameter
		//model.addAttribute("pstSalesOrdIdParam", params.get("pstSalesOrdIdParam"));
		//model.addAttribute("pstDealerDelvryCntId", params.get("pstDealerDelvryCntId"));
		//model.addAttribute("pstDealerMailCntId", params.get("pstDealerMailCntId"));
		//model.addAttribute("pstDealerDelvryAddId", params.get("pstDealerDelvryAddId"));
		//model.addAttribute("pstDealerMailAddId", params.get("pstDealerMailAddId"));
		
		return "sales/pst/pstRequestDoEditPop";
	}
	
	
	/**
	 * 화면 호출. -PST Stock List (초기화면)
	 */
	@RequestMapping(value = "/getPstRequestDOStockEditPop.do")
	public String getPstRequestDOStockEditPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		//params.put("pstSalesOrdId", "128");			// 임시
		//params.put("pstRefNo", "PSO0000128");			// 임시
		
		logger.debug((String)params.get("pstSalesOrdId"));
		logger.debug((String)params.get("pstRefNo"));

		model.addAttribute("pstSalesOrdId", params.get("pstSalesOrdId"));
		model.addAttribute("pstRefNo", params.get("pstRefNo"));
		
		return "sales/pst/pstRequestDoStockEditPop";
	}
	
	
	/**
	 * 화면 호출. -New pst (팝업화면)
	 */
	@RequestMapping(value = "/insertPstRequestDOPop.do")
	public String insertPstRequestDOPop(@RequestParam Map<String, Object>params, ModelMap model) {

		// Dealer combo box
		List<EgovMap> cmbDealerList = pstRequestDOService.pstNewCmbDealerList();
		
		model.addAttribute("cmbDealerList", cmbDealerList);
		
//		EgovMap pstMailAddrMain = pstRequestDOService.pstEditAddrDetailTopPop(params);

		
		return "sales/pst/pstRequestDoNewPop";
	}
	
	
	/**
	 * 화면 호출. -PST Stock List (데이터조회)
	 */
	@RequestMapping(value = "/pstNewCmbDealerList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> pstNewCmbDealerList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> cmbDealerList = pstRequestDOService.pstNewCmbDealerList();

		// 데이터 리턴.
		return ResponseEntity.ok(cmbDealerList);
	}
	
	
	/**
	 * 화면 호출. -PST Stock List (데이터조회)
	 */
	@RequestMapping(value = "/dealerInfo.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> dealerInfo(@RequestParam Map<String, Object>params, ModelMap model) {
		
		Map<String, Object> map = new HashMap();
		
		EgovMap dealerInfo = pstRequestDOService.pstNewParticularInfo(params);
		
		logger.info("dealerNric::::::::::::::::::::::::: : " + dealerInfo.get("dealerNric"));
		map.put("dealerEmail", dealerInfo.get("dealerEmail"));
		map.put("dealerNric", dealerInfo.get("dealerNric"));
		map.put("dealerBrnchId", dealerInfo.get("dealerBrnchId"));
		map.put("groupCode", dealerInfo.get("dealerBrnchId"));
		
		// MAIN만 가져오기.
		params.put("stusCode", 9);
		
		EgovMap pstMailAddrMain = pstRequestDOService.pstEditAddrDetailTopPop(params);
		EgovMap pstNewContactPop = pstRequestDOService.pstNewContactPop(params);
				
		List<EgovMap> cmbDealerBrnchList = pstRequestDOService.pstNewCmbDealerChgList(map);
//		model.addAttribute("cmbDealerBrnchList", cmbDealerBrnchList);
		
		map.put("brnchId", cmbDealerBrnchList.get(0).get("codeId"));
		map.put("brnchCodeName", cmbDealerBrnchList.get(0).get("codeName"));
		
		map.put("addrDtl", pstMailAddrMain.get("addrDtl"));
		map.put("street", pstMailAddrMain.get("street"));
		map.put("area", pstMailAddrMain.get("area"));
		map.put("city", pstMailAddrMain.get("city"));
		map.put("postcode", pstMailAddrMain.get("postcode"));
		map.put("state", pstMailAddrMain.get("state"));
		map.put("country", pstMailAddrMain.get("country"));
		
		map.put("cntName", pstNewContactPop.get("cntName"));
		map.put("dealerIniCd", pstNewContactPop.get("dealerInitialCode"));
		map.put("gender", pstNewContactPop.get("gender"));
		map.put("nric", pstNewContactPop.get("nric"));
		map.put("raceName", pstNewContactPop.get("raceName"));
		map.put("telf", pstNewContactPop.get("telf"));
		map.put("telM1", pstNewContactPop.get("telM1"));
		map.put("telR", pstNewContactPop.get("telR"));
		map.put("telO", pstNewContactPop.get("telO"));
		
		
		// 데이터 리턴.
		return ResponseEntity.ok(map);
	}
	
	
	/**
	 * 화면 호출. -NEW PST Branch List (데이터조회)
	 */
	@RequestMapping(value = "/pstNewCmbDealerBrnchList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> pstNewCmbDealerBrnchList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> cmbDealerBrnchList = pstRequestDOService.pstNewCmbDealerChgList(params);
		
		logger.info("dealerNric::::::::::::::::::::::::: : " + params.toString());

		
		// 데이터 리턴.
		return ResponseEntity.ok(cmbDealerBrnchList);
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
				
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		
		PSTSalesMVO pstSalesMVO = pstRequestDOForm.getPstSalesMVO();

		logger.info("##### PSTRequestDOController.updateStockList START #####");
		logger.info("pstSalesMVO.getPstSalesOrdId() : " + pstSalesMVO.getPstSalesOrdId());
		logger.info("updateList::::::::::::::::::::::::: : " + updateList.toString());
		
		List<PSTSalesDVO> pstSalesDVOList = new ArrayList<>();
		//PSTSalesDVO pstSalesDVO = null;
		
		// 반드시 서비스 호출하여 비지니스 처리. 
		updateList.forEach(form -> {
//			logger.debug(" add id : {}", form.getId());
//			logger.debug(" add name : {}", form.getName());
			logger.debug(" add date : {}", form.getPstStockRem());
			
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
			pstSalesDVO.setPstStockRem(form.getPstStockRem());
			pstSalesDVO.setCrtUserId(sessionVO.getUserId());
			
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
	
	
	/**
	 * 화면 호출. -Add/Edit Address (팝업화면)
	 */
	@RequestMapping(value = "/editAddrDtPop.do")
	public String editAddrDtPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		logger.debug((String)params.get("pstSalesOrdId"));
		logger.debug((String)params.get("pstRefNo"));
		logger.debug("dealerId Edit :: "+params.get("dealerId"));

		// MAIN만 가져오기.
		params.put("stusCode", 9);
		
		EgovMap pstMailAddrMain = pstRequestDOService.pstEditAddrDetailTopPop(params);
//		List<EgovMap> pstMailAddrList = pstRequestDOService.pstEditAddrDetailListPop(params);
		
		model.addAttribute("pstMailAddr", pstMailAddrMain);
		model.addAttribute("dealerId", params.get("dealerId"));
		model.addAttribute("pstSalesOrdId", params.get("pstSalesOrdId"));
		model.addAttribute("pstRefNo", params.get("pstRefNo"));
		
		return "sales/pst/pstEditDealerAddressPop";
	}
	
	
	/**
	 * 화면 호출. -Add/Edit Address (팝업화면)
	 */
	@RequestMapping(value = "/getAddrJsonListPop", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getAddrJsonListPop(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> pstMailAddrList = pstRequestDOService.pstEditAddrDetailListPop(params);

		// 데이터 리턴.
		return ResponseEntity.ok(pstMailAddrList);
	}
}
