package com.coway.trust.web.sales.pos;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/pos")
public class PosController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PosController.class);
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@Resource(name = "posService")
	private PosService posService;
	
	@RequestMapping(value = "/selectPosList.do")
	public String selectPosList(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		LOGGER.info("###### Post List Start ###########");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		//TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)
		
		return "sales/pos/posList";
	}
	
	
	@RequestMapping(value = "/selectPosModuleCodeList")
	public ResponseEntity<List<EgovMap>> selectPosModuleCodeList(@RequestParam Map<String, Object> params , @RequestParam(value = "codeIn[]") List<String> arr) throws Exception{
		
		LOGGER.info("###### selectPosModuleCodeList Start ###########");
		
		List<EgovMap> codeList = null;
		params.put("codeArray", arr);
		
		codeList = posService.selectPosModuleCodeList(params);
		
		return ResponseEntity.ok(codeList);
		
	}
	
	
	@RequestMapping(value = "/selectStatusCodeList")
	public ResponseEntity<List<EgovMap>> selectStatusCodeList(@RequestParam Map<String, Object> params) throws Exception{
		
		LOGGER.info("###### selectStatusCodeList Start ###########");
		
		List<EgovMap> codeList = null;
		
		codeList = posService.selectStatusCodeList(params);
		
		return ResponseEntity.ok(codeList);
	}
 	
	
	@RequestMapping(value = "/selectWhBrnchList")
	public ResponseEntity<List<EgovMap>> selectWhBrnchList () throws Exception{
		
		List<EgovMap> codeList = null;
		
		codeList = posService.selectWhBrnchList();
		
		return ResponseEntity.ok(codeList);
		
	}
	
	
	@RequestMapping(value = "/selectWarehouse")
	public ResponseEntity<EgovMap> selectWarehouse(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap codeMap = null;
		
		codeMap = posService.selectWarehouse(params);
		
		return ResponseEntity.ok(codeMap);
		
	}
	
	
	@RequestMapping(value = "/selectPosJsonList")
	public ResponseEntity<List<EgovMap>> selectPosJsonList (@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{
		
		List<EgovMap> listMap = null;
		
		//params
		String systemArray[] = request.getParameterValues("posTypeId");
		String statusArray[] = request.getParameterValues("posStatusId");
		
		params.put("systemArray", systemArray);
		params.put("statusArray", statusArray);
		
		listMap = posService.selectPosJsonList(params);
		
		return ResponseEntity.ok(listMap);
		
	}
	
	
	@RequestMapping(value = "/posSystemPop.do")
	public String posSystemPop(@RequestParam Map<String, Object> params,  ModelMap model) throws Exception{
		
	   SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	   
		params.put("userId", sessionVO.getUserId());
		
		EgovMap memCodeMap = null;
		EgovMap locMap = null;
		LOGGER.info("############################# /posSystemPop.do Start! #############");
		memCodeMap = posService.getMemCode(params); //get Brncn ID
		
		if(memCodeMap != null){
			
			if(memCodeMap.get("brnch") != null){ //BRNCH
				LOGGER.info("################ brnchId : " + memCodeMap.get("brnch"));
				params.put("brnchId", memCodeMap.get("brnch"));
				locMap = posService.selectWarehouse(params);
			}
			
		}
		
		model.addAttribute("memCodeMap", memCodeMap);
		model.addAttribute("locMap", locMap);
		
		return "sales/pos/posSystemPop";
	}
	
	
	@RequestMapping(value = "/posItmSrchPop.do")
	public String posItmSrchPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		//Params translate
		model.addAttribute("posSystemModuleType", params.get("insPosModuleType"));
		model.addAttribute("posSystemType", params.get("insPosSystemType"));
		model.addAttribute("whBrnchId", params.get("hidLocId"));
		model.addAttribute("", params.get("hidLocDesc"));
		
		return "sales/pos/posItmSrchPop";
		
	}
	
	
	@RequestMapping(value = "/selectPSMItmTypeList")
	public ResponseEntity<List<EgovMap>> selectPSMItmTypeList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> codeList = null;
		codeList = posService.selectPSMItmTypeList(params);
		
		return ResponseEntity.ok(codeList);
	}
	
	@RequestMapping(value = "/selectPSMItmTypeDeductionList")
	public ResponseEntity<List<EgovMap>> selectPSMItmTypeDeductionList(@RequestParam Map<String, Object> params, @RequestParam(value = "exceptCodes[]")  String[] exceptArr) throws Exception{
		
		List<EgovMap> codeList = null;
		
		params.put("exArr", exceptArr);
		
		LOGGER.info("############# selectPSMItmTypeList params : " + params.toString() );
		
		codeList = posService.selectPSMItmTypeList(params);
		
		return ResponseEntity.ok(codeList);
	}
	
	
	@RequestMapping(value = "/selectPIItmTypeList")
	public ResponseEntity<List<EgovMap>> selectPIItmTypeList() throws Exception{
		
		List<EgovMap> codeList = null;
		codeList = posService.selectPIItmTypeList();
		
		return ResponseEntity.ok(codeList);
	}
	
	
	@RequestMapping(value = "/selectPIItmList")
	public ResponseEntity<List<EgovMap>> selectPIItmList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{
		
		List<EgovMap> codeList = null;
		
		String itmIdArray [] = request.getParameterValues("itmLists"); 
		params.put("itmIdArray", itmIdArray);
		
		codeList = posService.selectPIItmList(params);
		return ResponseEntity.ok(codeList);
	}
	
	
	@RequestMapping(value = "/selectPSMItmList")
	public ResponseEntity<List<EgovMap>> selectPSMItmList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> codeList = null;
		codeList = posService.selectPSMItmList(params);
		return ResponseEntity.ok(codeList);
		
	}
	
	
	@RequestMapping(value = "/chkStockList")
	public ResponseEntity<List<EgovMap>> chkStockList (@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{
		
		
		String stkId[] = request.getParameterValues("itmLists");
		params.put("stkId", stkId);
		
		List<EgovMap> stokList = null;
		stokList = posService.chkStockList(params);
		
		return ResponseEntity.ok(stokList);
	}
	
	
	@RequestMapping(value = "/getReasonCodeList")
	public ResponseEntity<List<EgovMap>> getReasonCodeList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> codeList = null;
		codeList = posService.getReasonCodeList(params);
		
		return ResponseEntity.ok(codeList);
	}
	
	
	@RequestMapping(value = "/posFilterSrchPop.do" )
	public String posFilterSrchPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		model.addAttribute("basketStkCode", params.get("basketStkCode"));
		model.addAttribute("tempString", params.get("tempString"));
		
		return "sales/pos/posFilterSerialSrchPop";
	}

	
	@RequestMapping(value = "/getFilterSerialNum")
	public ResponseEntity<List<EgovMap>> getFilterSerialNum (@RequestParam Map<String, Object> params) throws Exception{
		//Session
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		List<EgovMap> serialList = null;
		serialList = posService.getFilterSerialNum(params);
		
		return ResponseEntity.ok(serialList);
	}
	
	
	@RequestMapping(value = "/getFilterSerialReNum")
	public ResponseEntity<List<EgovMap>> getFilterSerialReNum (@RequestParam Map<String, Object> params , @RequestParam(value = "tempSerialArr[]") String[] tempSerialArr) throws Exception{ 
		//Session
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
	 	params.put("serialArr", tempSerialArr);
		
		List<EgovMap> serialList = null;
		serialList = posService.getFilterSerialNum(params);
		
		return ResponseEntity.ok(serialList);
	}
	
	
	@RequestMapping(value = "/getConfirmFilterListAjax")
	public ResponseEntity<List<EgovMap>> getConfirmFilterListAjax(@RequestParam(value = "toArr[]") String[] toArr , @RequestParam Map<String, Object> params) throws Exception{
		
		//Session
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		
		//param Setting
		params.put("userId", sessionVO.getUserId());
		params.put("filterArr", toArr);
		List<EgovMap> filterList = null;
		filterList = posService.getConfirmFilterListAjax(params);
		
		return ResponseEntity.ok(filterList);
		
		
	}
	
	
	@RequestMapping(value = "/insertPos.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertPos(@RequestBody Map<String, Object> params) throws Exception{
		LOGGER.info("###############################################################################");
		LOGGER.info("###############################################################################");
		LOGGER.info("###############################################################################");
		LOGGER.info("##########  ----- params.toString : " + params.toString());
		LOGGER.info("###############################################################################");
		LOGGER.info("###############################################################################");
		LOGGER.info("###############################################################################");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		params.put("userDeptId", sessionVO.getUserDeptId());
		params.put("userName", sessionVO.getUserName());
		Map<String, Object> retunMap = null;
		retunMap = posService.insertPos(params);
		
		return ResponseEntity.ok(retunMap);
		
	}
	
	@RequestMapping(value = "/posMemUploadPop.do")
	public String posMemUploadPop (@RequestParam Map<String, Object> params) throws Exception{
		
		return "sales/pos/posMemUploadPop";
	}
	
	
	@RequestMapping(value = "/getUploadMemList")   
	public ResponseEntity<List<EgovMap>> getUploadMemList (@RequestParam Map<String, Object> params, @RequestParam(value = "memIdArray[]") String[] memIdArray) throws Exception{
		List<EgovMap> memList = null;
		
		//Params
		params.put("memberIdArr", memIdArray);
		
		memList = posService.getUploadMemList(params);
		
		return ResponseEntity.ok(memList);
	}
}
