package com.coway.trust.web.logistics.sirim;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.biz.logistics.sirim.SirimReceiveService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/sirim")
public class SirimReceiveController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "SirimReceiveService")
	private SirimReceiveService SirimReceiveService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/sirimReceive.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/sirim/sirimReceive";
	}

	@RequestMapping(value = "/sirimReceivePop.do")
	public String sirimReceivePop(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/sirim/sirimReceive";
	}


	//셀렉트박스 조회
	@RequestMapping(value = "/receiveWarehouseList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> receiveWarehouseList(@RequestParam Map<String, Object> params) {
		logger.debug("%%%%%%%%warehouseList%%%%%%%: {}", params.get("groupCode"));

		List<EgovMap> warehouseList = SirimReceiveService.receiveWarehouseList(params);

		return ResponseEntity.ok(warehouseList);
	}




	@RequestMapping(value = "/selectReceiveList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectReceiveList(@RequestBody Map<String, Object> params, Model model) {

		logger.debug("%%%%%%%%searchTransitNo%%%%%%%: {}",params.get("searchTransitNo") );
		logger.debug("%%%%%%%%searchTransitStatus%%%%%%%: {}",params.get("searchTransitStatus") );
		logger.debug("%%%%%%%%searchWarehouse%%%%%%%: {}",params.get("searchWarehouse") );
		//params.put("searchWarehouse", "DSC-CH-A");
		//params.put("searchWarehouse", "null");

		List<EgovMap> list = SirimReceiveService.selectReceiveList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/detailReceiveList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> detailReceiveList(@RequestBody Map<String, Object> params, Model model) {

		logger.debug("rnsitId   ?? ::::::: {}",params.get("trnsitId") );
		logger.debug("srmResultStusId   ?? ::::::: {}",params.get("srmResultStusId") );
		logger.debug("SRM_TRANSF_ID   ?? ::::::: {}",params.get("srmResultStusId") );



		List<EgovMap> list = SirimReceiveService.detailReceiveList(params);

	/*for (int i = 0; i < list.size(); i++) {
			logger.debug("detailReceiveList ************  ?? ::::::: {}",list.get(i) );
	}*/
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}



	@RequestMapping(value = "/getSirimReceiveInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> getSirimReceiveInfo(@RequestBody Map<String, Object> params, Model model) {

		logger.debug("rnsitId   ?? ::::::: {}",params.get("trnsitId") );


		List<EgovMap> list = SirimReceiveService.getSirimReceiveInfo(params);
		for (int i = 0; i < list.size(); i++) {
			logger.debug("detailReceiveList   ?? ::::::: {}",list.get(i) );
		}
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/InsertReceiveInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> InsertReceiveInfo(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {

		Map<String, Object> InsertReceiveMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		//List<EgovMap> ItemsAddList = (List<EgovMap>) params.get("select");
		List<EgovMap> ItemsAddList = (List<EgovMap>) params.get("checked");

		for (int i = 0; i < ItemsAddList.size(); i++) {
			logger.debug("ItemsAddList ???????? : {}", ItemsAddList.get(i));
		}

//		for (int i = 0 ; i < ItemsAddList.size() ; i++){
//			Map<String, Object> ItemsList = ItemsAddList.get(i);
//			Map<String, Object> ItemsListMap = (Map<String, Object>)ItemsList.get("item");
//			logger.debug("srmNo ???????? : {}", ItemsListMap.get("srmNo"));
//		}

//		logger.debug("receiveInfoTransitNo  : {}", InsertReceiveMap.get("receiveInfoTransitNo"));
//		logger.debug("receiveInfoTransitDate  : {}", InsertReceiveMap.get("receiveInfoTransitDate"));
//		logger.debug("receiveInfoTransitStatus  : {}", InsertReceiveMap.get("receiveInfoTransitStatus"));
//		logger.debug("receiveInfoTransitBy  : {}", InsertReceiveMap.get("receiveInfoTransitBy"));
//		logger.debug("receiveInfoTransitLocation  : {}", InsertReceiveMap.get("receiveInfoTransitLocation"));
//		logger.debug("receiveInfoCourier  : {}", InsertReceiveMap.get("receiveInfoCourier"));
//		logger.debug("receiveInfoTotalSirimTransit  : {}", InsertReceiveMap.get("receiveInfoTotalSirimTransit"));
		logger.debug("receiveStatus  : {}", InsertReceiveMap.get("receiveStatus"));
//		logger.debug("receiveRadio  : {}", InsertReceiveMap.get("receiveRadio"));
//		logger.debug("SirimLocTo  : {}", InsertReceiveMap.get("SirimLocTo"));
//		logger.debug("SirimLocFrom  : {}", InsertReceiveMap.get("SirimLocFrom"));


		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		String retMsg = AppConstants.MSG_SUCCESS;

		Map<String, Object> map = new HashMap();

		try {
			SirimReceiveService.InsertReceiveInfo(InsertReceiveMap, ItemsAddList,loginId);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);
	}





}
