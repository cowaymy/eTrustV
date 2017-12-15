package com.coway.trust.web.services.as;

import java.io.File;
import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.services.as.CompensationService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.ibm.icu.text.DateFormat;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/services/compensation")

public class CompensationController {
	private static final Logger logger = LoggerFactory.getLogger(CompensationController.class);
	
	@Value("${com.file.upload.path}")
	private String uploadDir;
	
	@Resource(name = "CompensationService")
	private CompensationService compensationService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;	
	
	@Autowired
	private FileApplication fileApplication;
	
	@RequestMapping(value = "/compensationList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		// 호출될 화면
		return "services/as/compensationList";
	}
	
	@RequestMapping(value = "/compensationAddPop.do")
	public String addPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		logger.debug("======================================================================================");
		logger.debug("===============================compensationPop params {} ==========================================", params.toString());
		logger.debug("======================================================================================");
		
		return "services/as/compensationAddPop";
	}

	@RequestMapping(value = "/compensationEditPop.do")
	public String editPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		logger.debug("======================================================================================");
		logger.debug("===============================compensationPop params {} ==========================================", params.toString());
		logger.debug("======================================================================================");
		 
		params.put("compNo", params.get("compNo"));

		EgovMap compensationView = compensationService.selectCompenSationView(params);
		model.put("compensationView", compensationView);
		
		model.put("compNo", params.get("compNo"));
		
		logger.debug("======================================================================================");
		logger.debug("===============================compensationPop model {} ==========================================", model.toString());
		logger.debug("======================================================================================");
		
		
		return "services/as/compensationEditPop";
	}
		
	@RequestMapping(value = "/compensationViewPop.do")
	public String viewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		logger.debug("======================================================================================");
		logger.debug("===============================compensationPop params {} ==========================================", params.toString());
		logger.debug("======================================================================================");
		 
		params.put("compNo", params.get("compNo"));

		EgovMap compensationView = compensationService.selectCompenSationView(params);
		model.put("compensationView", compensationView);
		
		model.put("compNo", params.get("compNo"));
		

		return "services/as/compensationViewPop";
	}
	
	
	@RequestMapping(value = "/selCompensation.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selInhouseList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("selCompensation in.............");
		logger.debug("params : {}", params);
		
		List<EgovMap> mList = compensationService.selCompensationList(params);
		
	
		logger.debug("mList : {}", mList);
		return ResponseEntity.ok(mList);
	}
	
	@RequestMapping(value = "/insertCompensation.do",method = RequestMethod.POST)
	public ResponseEntity<EgovMap> insertCompensation(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception{
		
		logger.debug("======================================================================================");
		logger.debug("===============================compensationPop insertCompensation==========================================");
		logger.debug("======================================================================================");
		params.put("updator", sessionVO.getUserId());
		
		logger.debug("params : {}", params);
//		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "compensation" + File.separator + "DCF", 1024 * 1024 * 6, true);
		
		//EgovMap result = new EgovMap();
		
		params.put("userId", sessionVO.getUserId());
		params.put("branchId", sessionVO.getUserBranchId());
		params.put("deptId", sessionVO.getUserDeptId());	
		
		params.put("list", list);	
		
		
		logger.debug("======================================================================================");
		logger.debug("===============================compensationPop insertCompensation file List {}==========================================", list);
		logger.debug("======================================================================================");
		
		logger.debug("list SIZE=============" + list.size());

		if(list.size() > 0){

			params.put("hasAttach", 1);
			params.put("fileName", list.get(0).getServerSubPath()+ list.get(0).getFileName());			

			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}
		
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat transFormat1 = new SimpleDateFormat("yyyy-MM-dd");
		
		DateFormat sdFormat = new SimpleDateFormat("ddMMyyyy");
		DateFormat sdFormat1 = new SimpleDateFormat("dd-MM-yyyy");
		
		String issue = (String)params.get("issueDt");
		String compdate = (String)params.get("compDt"); 
		
		params.put("issueDt", transFormat.format(sdFormat.parse(issue.replaceAll("/", ""))));
		params.put("compDt", transFormat.format(sdFormat.parse(compdate.replaceAll("/", ""))));
		
		EgovMap resultValue = compensationService.insertCompensation(params);
	 
		return ResponseEntity.ok(resultValue);
	}
	
	@RequestMapping(value = "/updateCompensation.do",method = RequestMethod.POST)
	public ResponseEntity<EgovMap> updateCompensation(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception{	
		
		params.put("updator", sessionVO.getUserId());
		
		logger.debug("params : {}", params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "compensation" + File.separator + "DCF", 1024 * 1024 * 6, true);
		
		//EgovMap result = new EgovMap();
		
		params.put("userId", sessionVO.getUserId());
		params.put("branchId", sessionVO.getUserBranchId());
		params.put("deptId", sessionVO.getUserDeptId());	
		
		params.put("list", list);	
		
		if(list.size() > 0){

			params.put("hasAttach", 1);
			params.put("fileName", list.get(0).getServerSubPath()+ list.get(0).getFileName());			

			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}
		
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat transFormat1 = new SimpleDateFormat("yyyy-MM-dd");
		
		DateFormat sdFormat = new SimpleDateFormat("ddMMyyyy");
		DateFormat sdFormat1 = new SimpleDateFormat("dd-MM-yyyy");
		
		//params.put("attachFile" , params.get("fileGroupKey"));
		
		String issue = (String)params.get("issueDt");
		String compdate = (String)params.get("compDt"); 
		
		params.put("issueDt", transFormat.format(sdFormat.parse(issue.replaceAll("/", ""))));
		params.put("compDt", transFormat.format(sdFormat.parse(compdate.replaceAll("/", ""))));
		
		EgovMap resultValue = compensationService.updateCompensation(params);
		
		 
		return ResponseEntity.ok(resultValue);
	}
	
	//selectSalesOrdNoInfo
	@RequestMapping(value = "/selectSalesOrdNoInfo.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSalesOrdNoInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("selectSalesOrdNoInfo in.............");
		logger.debug("params : {}", params);
		
		logger.debug("======================================================================================");
		logger.debug("===============================compensationPop params {} ==========================================", params.toString());
		logger.debug("======================================================================================");
		 
		
		List<EgovMap> mList = compensationService.selectSalesOrdNoInfo(params);
		
	
		logger.debug("mList : {}", mList);
		return ResponseEntity.ok(mList);
	}
	
}
