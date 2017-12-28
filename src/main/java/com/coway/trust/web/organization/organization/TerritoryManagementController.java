package com.coway.trust.web.organization.organization;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.organization.organization.TerritoryManagementService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.excel.ExcelReadComponent;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization/territory")

public class TerritoryManagementController {
	private static final Logger logger = LoggerFactory.getLogger(TerritoryManagementController.class);
	
	@Resource(name = "territoryManagementService")
	private TerritoryManagementService territoryManagementService;
	
	@Resource(name = "commonService") 
	private CommonService commonService;
	
	
	@Autowired
	private ExcelReadComponent excelReadComponent;

	
	
	/**
	 * organization territoryList page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/territoryList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		// 호출될 화면
		return "organization/organization/territoryList";
	}
	
	
	

	/**
	 * organization territoryList upload page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/territoryNew.do")
	public String territoryNew(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("memType", params.get("memType"));
		// 호출될 화면
		return "organization/organization/territoryNewPop";
	}
	
	 
	
	@RequestMapping(value = "/excelUpload", method = RequestMethod.POST)
	public ResponseEntity readExcel(MultipartHttpServletRequest request,SessionVO sessionVO) throws IOException, InvalidFormatException {

		
		ReturnMessage message = new ReturnMessage();
		
		logger.debug("comBranchTypep : {}", request.getParameter("comBranchTypep"));
		
		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<TerritoryRawDataVO> vos = excelReadComponent.readExcelToList(multipartFile, TerritoryRawDataVO::create);

		for (TerritoryRawDataVO vo : vos) {
			   logger.debug("vo {}", vo.toString());
		}  
		
		//step 1 vaild 
		Map param = new HashMap();
		param.put("comBranchTypep", request.getParameter("comBranchTypep"));
		param.put("voList", vos);
		
		EgovMap  vailMap = territoryManagementService.uploadVaild(param,sessionVO);
		
		
		logger.debug("vailMap {}", vailMap.toString());
		
		if((boolean)vailMap.get("isErr")){
			message.setCode(AppConstants.FAIL);
			message.setMessage((String)vailMap.get("errMsg"));
		}else{
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("Excel Upload Success");
		}
		
		//결과 
		return ResponseEntity.ok(message);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTerritoryList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		String[] branchTypeList = request.getParameterValues("comBranchType");
		params.put("branchTypeList", branchTypeList);
		logger.debug("branchTypeList {}", branchTypeList);
		List<EgovMap> territoryList = territoryManagementService.selectTerritory(params);
		logger.debug("territoryList {}", territoryList);
		return ResponseEntity.ok(territoryList);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTerritoryDetailList( @RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> territoryDetailList = territoryManagementService.selectMagicAddress(params);
		logger.debug("territoryDetailList {}", territoryDetailList);
		return ResponseEntity.ok(territoryDetailList);
	}
	
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/comfirmTerritory.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>selectComfirmTerritory(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		EgovMap rtm = new EgovMap();
		
		boolean success = territoryManagementService.updateMagicAddressCode(params);
		if(success){
			message.setMessage("Confirm Success");
		}else{
			message.setMessage("Confirm Fail");
		}
		return ResponseEntity.ok(message);
	}
	
	/**
	 * organization territoryList > Current Territory Search page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/territorySearchPop.do")
	public String territorySearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("memType", params.get("memType"));
		// 호출될 화면
		return "organization/organization/territorySearchPop";
	}
	
	/**
	 * Search Branch Code list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectBranchCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranchCode( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		List<EgovMap> branchCodeList = territoryManagementService.selectBranchCode(params);
		logger.debug("branchCodeList {}", branchCodeList);
		return ResponseEntity.ok(branchCodeList);
	}
	
	/**
	 * Search State list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectState.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectState( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		List<EgovMap> stateList = territoryManagementService.selectState(params);
		logger.debug("stateList {}", stateList);
		return ResponseEntity.ok(stateList);
	}
	
	/**
	 * Search Current Territory list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCurrentTerritory.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCurrentTerritory( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		List<EgovMap> currentTerritoryList = territoryManagementService.selectCurrentTerritory(params);
		//logger.debug("currentTerritoryList {}", currentTerritoryList);
		return ResponseEntity.ok(currentTerritoryList);
	}
	
}
