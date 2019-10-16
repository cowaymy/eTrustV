/**
 *
 */
package com.coway.trust.web.sales.pst;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.pst.PSTRequestDOService;
import com.coway.trust.biz.sales.pst.PSTRequestDOVO;
import com.coway.trust.biz.sales.pst.PSTSalesDVO;
import com.coway.trust.biz.sales.pst.PSTSalesMVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;

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

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;


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

		if(request.getParameterValues("cmbPstType") != null){
			String[] pstTypeList = request.getParameterValues("cmbPstType");
			params.put("pstTypeList", pstTypeList);
		}

		if(params != null && !"".equals(params.toString().trim())){
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
		EgovMap getRate = pstRequestDOService.getRate();
		logger.info("##### pstMailContact #####" +pstMailContact.toString());
		logger.info("##### pstDeliveryContact #####" +pstDeliveryContact.toString());
		model.addAttribute("pstInfo", pstInfo);
		model.addAttribute("pstMailAddr", pstMailAddr);
		model.addAttribute("pstDeliveryAddr", pstDeliveryAddr);
		model.addAttribute("pstMailContact", pstMailContact);
		model.addAttribute("pstDeliveryContact", pstDeliveryContact);
		model.addAttribute("getRate", getRate);

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
		logger.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> " + params.toString());

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		// Dealer combo box - Dealer Type 입력 후 onchange로 인해 안씀.
//		List<EgovMap> cmbDealerList = pstRequestDOService.pstNewCmbDealerList();
		EgovMap getRate = pstRequestDOService.getRate();

//		model.addAttribute("cmbDealerList", cmbDealerList);
		model.addAttribute("userId", sessionVO.getUserId());
		model.addAttribute("getRate", getRate);
		model.addAttribute("dealerTypeFlag", params.get("dealerTypeFlag"));

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

		map.put("dealerAddId", pstMailAddrMain.get("dealerAddId"));
		map.put("areaId", pstMailAddrMain.get("areaId"));
		map.put("addrDtl", pstMailAddrMain.get("addrDtl"));
		map.put("street", pstMailAddrMain.get("street"));
		map.put("area", pstMailAddrMain.get("area"));
		map.put("city", pstMailAddrMain.get("city"));
		map.put("postcode", pstMailAddrMain.get("postcode"));
		map.put("state", pstMailAddrMain.get("state"));
		map.put("country", pstMailAddrMain.get("country"));

		map.put("dealerCntId", pstNewContactPop.get("dealerCntId"));
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

		logger.debug("params.toString() :::::::::::::::::::::::::::::::::::::::::::::::: "+params.toString());
//		params.put("dealerId", params.get("editDealerId"));
		List<EgovMap> pstMailAddrList = pstRequestDOService.pstEditAddrDetailListPop(params);

		// 데이터 리턴.
		return ResponseEntity.ok(pstMailAddrList);
	}


	/**
	 * 화면 호출. -Add/Edit Address (팝업화면)
	 */
	@RequestMapping(value = "/pstAnotherAddrJsonListPop", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> pstAnotherAddrJsonListPop(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("params.toString() :::::::::::::::::::::::::::::::::::::::::::::::: "+params.toString());
//		params.put("dealerId", params.get("editDealerId"));
		List<EgovMap> pstMailAddrList = pstRequestDOService.pstEditAddrDetailListPop(params);

		// 데이터 리턴.
		return ResponseEntity.ok(pstMailAddrList);
	}


	/**
	 * Add new Address(Edit)
	 * @param model
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/updateDealerNewAddressPop.do")
	public String updateDealerNewAddressPop(@RequestParam Map<String, Object> params , ModelMap model) throws Exception{

		model.addAttribute("insDealerId", params.get("dealerId"));

		return "sales/pst/pstAddDealerAddressPop";
	}


	/**
	 * Add new Contact(Edit)
	 * @param model
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/updateDealerNewContactPop.do")
	public String updateDealerNewContactPop(@RequestParam Map<String, Object> params , ModelMap model) throws Exception{

		model.addAttribute("insDealerId", params.get("dealerId"));

		return "sales/pst/pstAddDealerContactPop";
	}


	/**
	 * 화면 호출. -New pst (팝업화면)
	 */
	@RequestMapping(value = "/addStockItempPop.do")
	public String addStockItempPop(@RequestParam Map<String, Object>params, ModelMap model) {

		// Dealer combo box
//		List<EgovMap> cmbDealerList = pstRequestDOService.pstNewCmbDealerList();

//		model.addAttribute("cmbDealerList", cmbDealerList);

//		EgovMap pstMailAddrMain = pstRequestDOService.pstEditAddrDetailTopPop(params);


		return "sales/pst/pstNewAddStockItemPop";
	}


	/**
	 * 화면 호출. -Add/Edit Address (팝업화면)
	 */
	@RequestMapping(value = "/getStockItemJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getStockItemJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		List<EgovMap> getStockItmList = pstRequestDOService.cmbChgStockItemList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(getStockItmList);
	}


	/**
	 * New save
	 */
	@RequestMapping(value = "/insertNewRequestDO.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertNewRequestDO(@RequestBody PSTRequestDOForm pstRequestDOForm,
			Model model) {

		GridDataSet<PSTStockListGridForm> dataSet = pstRequestDOForm.getDataSet();
		List<PSTStockListGridForm> addList    = dataSet.getAll();    // 추가 리스트 얻기

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		int crtSeqSAL0062D = pstRequestDOService.crtSeqSAL0062D();			// PST_SALES_ORD_ID    SEQ

//		String crtSeqSAL0061D = pstRequestDOService.crtSeqSAL0061D();		// PST_TRNSIT_ID		  SEQ
		String newPstRefNo = "";
		int newPstRefNoRLength = Integer.toString(crtSeqSAL0062D).length() ;			// 생성된 PST_SALES_ORD_ID length
		logger.debug("newPstRefNoRLength :::::::::::::::::::::::::::::::::: "+newPstRefNoRLength);
		if(newPstRefNoRLength == 1){
			newPstRefNo = "PSO" + "000000" + Integer.toString(crtSeqSAL0062D);
		}else if(newPstRefNoRLength == 2){
			newPstRefNo = "PSO" + "00000" + Integer.toString(crtSeqSAL0062D);
		}else if(newPstRefNoRLength == 3){
			newPstRefNo = "PSO" + "0000" + Integer.toString(crtSeqSAL0062D);
		}else if(newPstRefNoRLength == 4){
			newPstRefNo = "PSO" + "000" + Integer.toString(crtSeqSAL0062D);
		}else if(newPstRefNoRLength == 5){
			newPstRefNo = "PSO" + "00" + Integer.toString(crtSeqSAL0062D);
		}else if(newPstRefNoRLength == 6){
			newPstRefNo = "PSO" + Integer.toString(crtSeqSAL0062D);
		}else{
			newPstRefNo = "PSO" + "000000" + Integer.toString(crtSeqSAL0062D);
		}

		PSTSalesMVO pstSalesMVO = pstRequestDOForm.getPstSalesMVO();		// Master
		pstSalesMVO.setPstSalesOrdId(crtSeqSAL0062D);
//		pstSalesMVO.setPstItmId(crtSeqSAL0063D);
//		pstSalesMVO.setPstTrnsitId(crtSeqSAL0061D);
		pstSalesMVO.setPstRefNo(newPstRefNo);
		pstSalesMVO.setPstStusId(1);
		pstSalesMVO.setCrtUserId(sessionVO.getUserId());

		int crtSeqSAL0063D = 0;
		logger.debug("pstSalesMVO :::::::::::::::::::::::::::::::::: "+crtSeqSAL0062D);
//		logger.debug("pstSalesMVO :::::::::::::::::::::::::::::::::: "+crtSeqSAL0063D);
		logger.debug("pstSalesMVO :::::::::::::::::::::::::::::::::: "+pstSalesMVO.getPic());
		logger.debug("pstSalesMVO :::::::::::::::::::::::::::::::::: "+pstSalesMVO.getPstCustPo());
		logger.debug("pstSalesMVO :::::::::::::::::::::::::::::::::: "+pstSalesMVO.getPstRem());
		logger.debug("pstSalesMVO :::::::::::::::::::::::::::::::::: "+pstSalesMVO.getPstDealerDelvryAddId());

		List<PSTSalesDVO> pstSalesDVOList = new ArrayList<>();					// Detail

		addList.forEach(form -> {

			PSTSalesDVO pstSalesDVO = new PSTSalesDVO();

			logger.debug("id   : "+form.getPstItmStkId());
			logger.debug("prc : "+form.getPstItmPrc());
			logger.debug("qty : "+form.getPstItmReqQty());
			logger.debug("tot : "+form.getPstItmId());
			logger.debug("tot : "+form.getPstItmTotPrc());
			logger.debug("tot : "+form.getPstItmTotPrc());

//			pstRequestDOService.crtSeqSAL0063D();		// PST_ITM_ID				  SEQ
			pstSalesDVO.setPstItmId(pstRequestDOService.crtSeqSAL0063D());
			pstSalesDVO.setPstSalesOrdId(crtSeqSAL0062D);
			pstSalesDVO.setPstItmStkId(form.getPstItmStkId());
			pstSalesDVO.setPstItmPrc(form.getPstItmPrc());
			pstSalesDVO.setPstItmReqQty(form.getPstItmReqQty());
			pstSalesDVO.setPstItmTotPrc(form.getPstItmTotPrc());
			pstSalesDVO.setPstItmDoQty(0);
			pstSalesDVO.setPstItmCanQty(0);
			pstSalesDVO.setPstItmBalQty(form.getPstItmReqQty());
			pstSalesDVO.setCrtUserId(sessionVO.getUserId());


			pstSalesDVOList.add(pstSalesDVO);
		});

		pstRequestDOService.insertNewReqOk(pstSalesDVOList, pstSalesMVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}


	/**
	 * Add new Address(Edit) After
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/insertDealerAddressInfo.do")
	public ResponseEntity<ReturnMessage> insertDealerAddressInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		int getDealerAddId = pstRequestDOService.crtSeqSAL0031D();
		params.put("getDealerAddId", getDealerAddId);
		params.put("stusCodeId", 1);
		pstRequestDOService.insertPstSAL0031D(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	/**
	 * Address Info Edit Set Main 주소 정보 메인 설정
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/updateDealerAddressSetMain.do")
	public ResponseEntity<ReturnMessage> updateDealerAddressSetMain(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		logger.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ " + params.get("dealerAddId"));
		pstRequestDOService.updateMainPstSAL0031D(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	/**
	 * Add new Contact(Edit) After
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/insertDealerContactInfo.do")
	public ResponseEntity<ReturnMessage> insertDealerContactInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		int getDealerCntId = pstRequestDOService.crtSeqSAL0032D();
		params.put("getDealerCntId", getDealerCntId);
		params.put("stusCodeId", 1);
		pstRequestDOService.insertPstSAL0032D(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	/**
	 * 화면 호출. -New pst (팝업화면)
	 */
	@RequestMapping(value = "/pstAnotherAddrPop.do")
	public String pstAnotherAddrPop(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.info("@@@@@@@@@@@@@@@ " + params.toString());
		model.addAttribute("dealerId", params.get("dealerId"));
		return "sales/pst/pstAnotherAddressPop";
	}


	/**
	 * 화면 호출. -New pst (팝업화면)
	 */
	@RequestMapping(value = "/pstUpdAddrPop.do")
	public String pstUpdAddrPop(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.info("###################3 :  " + params.toString());
		model.addAttribute("dealerId", params.get("dealerId"));
		params.put("pstDealerMailAddId", params.get("editDealerAddId"));
		EgovMap updAddrInfo = pstRequestDOService.pstRequestDOMailAddress(params);
		logger.info("########################### :  " + updAddrInfo.get("areaId"));
		model.addAttribute("updAddrInfo", updAddrInfo);

		return "sales/pst/pstUpdDealerAddressPop";
	}


	/**
	 * Add Update Address(Edit) After
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/updateDealerAddressInfo.do")
	public ResponseEntity<ReturnMessage> updateDealerAddressInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		pstRequestDOService.updatePstSAL0031D(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	/**
	 * Add Delete Address(Edit) After
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/delDealerAddress.do")
	public ResponseEntity<ReturnMessage> delDealerAddress(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		pstRequestDOService.delPstSAL0031D(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	/**
	 * 화면 호출. -Add/Edit Contact (팝업화면)
	 */
	@RequestMapping(value = "/editContDtPop.do")
	public String editContDtPop(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug((String)params.get("pstSalesOrdId"));
		logger.debug((String)params.get("pstRefNo"));
		logger.debug("dealerId Edit :: "+params.get("dealerId"));

		// MAIN만 가져오기.
		params.put("stusCode", 9);

		EgovMap pstMailContMain = pstRequestDOService.pstNewContactPop(params);
//		List<EgovMap> pstMailAddrList = pstRequestDOService.pstEditAddrDetailListPop(params);

		model.addAttribute("pstMailContMain", pstMailContMain);
		model.addAttribute("dealerId", params.get("dealerId"));
		model.addAttribute("pstSalesOrdId", params.get("pstSalesOrdId"));
		model.addAttribute("pstRefNo", params.get("pstRefNo"));

		return "sales/pst/pstEditDealerContactPop";
	}


	/**
	 * 화면 호출. -Add/Edit Contact (팝업화면)
	 */
	@RequestMapping(value = "/getContJsonListPop", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getContJsonListPop(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("params.toString() :::::::::::::::::::::::::::::::::::::::::::::::: "+params.toString());
//		params.put("dealerId", params.get("editDealerId"));
		List<EgovMap> pstMailContList = pstRequestDOService.pstNewContactListPop(params);

		// 데이터 리턴.
		return ResponseEntity.ok(pstMailContList);
	}


	/**
	 * 화면 호출. -Add/Edit Address (팝업화면)
	 */
	@RequestMapping(value = "/pstAnotherContJsonListPop", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> pstAnotherContJsonListPop(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("params.toString() :::::::::::::::::::::::::::::::::::::::::::::::: "+params.toString());
//		params.put("dealerId", params.get("editDealerId"));
		List<EgovMap> pstMailAddrList = pstRequestDOService.pstNewContactListPop(params);

		// 데이터 리턴.
		return ResponseEntity.ok(pstMailAddrList);
	}


	/**
	 * 화면 호출. -New pst (팝업화면)
	 */
	@RequestMapping(value = "/pstAnotherContPop.do")
	public String pstAnotherContPop(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.info("@@@@@@@@@@@@@@@ " + params.toString());
		model.addAttribute("dealerId", params.get("dealerId"));
		return "sales/pst/pstAnotherContactPop";
	}


	/**
	 * Address Info Edit Set Main 주소 정보 메인 설정
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/updateDealerContactSetMain.do")
	public ResponseEntity<ReturnMessage> updateDealerContactSetMain(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		logger.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ " + params.toString());
		pstRequestDOService.updateMainPstSAL0032D(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	/**
	 * PST Type Combo Box 구하기
	 */
	@RequestMapping(value = "/pstTypeCmbJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> pstTypeCmbJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		int dealerType = Integer.parseInt((String)params.get("groupCode"));	// recall, calcel, reversal cancel

		if(dealerType == 2575){
			String[] pstTypeList = {"2577", "2578"};
			params.put("pstTypeList", pstTypeList);
		}else{
			String[] pstTypeList = {"2579", "2580"};
			params.put("pstTypeList", pstTypeList);
		}

		List<EgovMap> pstTypeCmbList = pstRequestDOService.pstTypeCmbList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(pstTypeCmbList);
	}


	/**
	 * Dealer Type에 따른 Dealer Combo Box 구하기
	 */
	@RequestMapping(value = "/pstNewDealerInfo.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> pstNewDealerInfo(@RequestParam Map<String, Object>params, ModelMap model) {

//		int dealerType = Integer.parseInt((String)params.get("groupCode"));	// recall, calcel, reversal cancel

		logger.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ " + params.toString());
		List<EgovMap> dealerCmbList = pstRequestDOService.pstNewDealerInfo(params);

		// 데이터 리턴.
		return ResponseEntity.ok(dealerCmbList);
	}


	/**
	 * 화면 호출. -report pst (팝업화면)
	 */
	@RequestMapping(value = "/reportPstRequestDOPop.do")
	public String reportPstRequestDOPop(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.info("@@@@@@@@@@@@@@@ " + params.toString());

		EgovMap pstInfo = pstRequestDOService.pstRequestDOInfo(params);
		model.addAttribute("pstInfo", pstInfo);

		return "sales/pst/pstRequestDoReportPop";
	}


	/**
	 * Report Grid
	 */
	@RequestMapping(value = "/reportGrid.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> reportGrid(@RequestParam Map<String, Object>params, ModelMap model) {

//		int dealerType = Integer.parseInt((String)params.get("groupCode"));	// recall, calcel, reversal cancel

		logger.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ " + params.toString());
		List<EgovMap> reportGrid = pstRequestDOService.reportGrid(params);

		// 데이터 리턴.
		return ResponseEntity.ok(reportGrid);
	}

	@RequestMapping(value = "/uploadPSTFile", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> sampleUploadCommon(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		logger.debug("in  updateReTrBook ");
		logger.debug("params =====================================>>  " + params);


		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "PST" + File.separator + "PST", 1024 * 1024 * 6);

		params.put("userId", sessionVO.getUserId());
		params.put("branchId", sessionVO.getUserBranchId());
		params.put("deptId", sessionVO.getUserDeptId());

		params.put("list", list);

		logger.debug("list SIZE=============" + list.size());

		if(list.size() > 0){

			params.put("hasAttach", 1);
			params.put("fileName", params.get("fileName").toString());

			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params.get("fileGroupKey"));
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/uploadPSTAttachPop.do", method = {RequestMethod.POST,RequestMethod.GET})
	public String uploadAttachPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception {

		return "sales/pst/pstAttachmentFileUploadPop";
	}

}
