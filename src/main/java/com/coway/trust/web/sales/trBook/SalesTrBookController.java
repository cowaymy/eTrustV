package com.coway.trust.web.sales.trBook;

import java.io.File;
import java.util.ArrayList;
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
import com.coway.trust.biz.sales.trBook.SalesTrBookService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/trBook")
public class SalesTrBookController {

	private static final Logger logger = LoggerFactory.getLogger(SalesTrBookController.class);
	
	@Resource(name = "salesTrBookService")
	private SalesTrBookService salesTrBookService;	
	
	@Value("${com.file.upload.path}")
	private String uploadDir;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private FileApplication fileApplication;
	

	@RequestMapping(value = "/trBookMgmt.do")
	public String orderLedgerViewPop(@RequestParam Map<String, Object>params, ModelMap model){
		
		logger.debug("params ======================================>>> " + params);

		return "sales/trBook/trBookMgmt";
	}
	
	@RequestMapping(value = "/selectTrBookMgmtList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectTrBookMgmtList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		logger.debug("in  trBookMgmtList ");

		logger.debug("param ===================>>  " + params);
		String branch = sessionVO.getCode();
		String close = "";

		if ("".equals(branch) || null == branch) {
			branch = "HQ";
			params.put("trHolderType", "Member");
		}
		
		String[] stutus = request.getParameterValues("status");
		
		//List<Object> stutus = (List<Object>) params.get("status");
		logger.info("stutus : {} ", stutus.toString());
		if (0 < stutus.length) {
			for (int i = 0; i < stutus.length; i++) {
				
				int tmp = Integer.parseInt(String.valueOf(stutus[i]));
				if (36 == tmp) {
					params.put("Close", close);
				}
			}
		}

		params.put("branch", branch);
		params.put("stutus", stutus);
		// MBRSH_ID
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");

		List<EgovMap> list = salesTrBookService.selectTrBookList(params);

	
		return ResponseEntity.ok(list);
	}
	
	@RequestMapping(value = "/trBookMgmtDetailPop.do")
	public String trBookMgmtDetailPop(@RequestParam Map<String, Object>params, ModelMap model){
		
		logger.debug("params ======================================>>> " + params);
		
		EgovMap detailInfo = salesTrBookService.selectTrBookDetailInfo(params);
		model.addAttribute("detailInfo", detailInfo);
		
		List<EgovMap> detailList = salesTrBookService.selectTrBookDetailList(params);
		
		logger.debug(""+detailList);
		model.addAttribute("detailList", new Gson().toJson(detailList));

		return "sales/trBook/trBookMgmtDetailPop";
	}
	
	@RequestMapping(value = "/trBookAddSinglePop.do")
	public String trBookAddSinglePop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		
		logger.debug("params ======================================>>> " + params);
		model.addAttribute("branch", sessionVO.getCode());
		
		return "sales/trBook/trBookAddSinglePop";
	}
	
	@RequestMapping(value = "/trBookAddBulkPop.do")
	public String trBookAddBulkPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		
		logger.debug("params ======================================>>> " + params);
		model.addAttribute("branch", sessionVO.getUserBranchId());
		
		return "sales/trBook/trBookAddBulkPop";
	}	
	
	@RequestMapping(value = "/selectTrBookDup", method = RequestMethod.GET) 
	public ResponseEntity <ReturnMessage> selectTrBookDup(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		

		int result = salesTrBookService.selectTrBookDup(params);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectBranch", method = RequestMethod.GET) 
	public ResponseEntity <List<EgovMap>> selectBranch(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> result = salesTrBookService.selectBranch(params);

		return ResponseEntity.ok(result);
	}
	
	
	@RequestMapping(value = "/selectCourier", method = RequestMethod.GET) 
	public ResponseEntity <List<EgovMap>> selectCourier(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> result = salesTrBookService.selectCourier(params);
				
		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/selectMember", method = RequestMethod.GET) 
	public ResponseEntity <List<EgovMap>> selectMember(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		logger.debug("params =====================================>>  " + params);
		
		List<EgovMap> result = salesTrBookService.selectMember(params);
		
		return ResponseEntity.ok(result);
	}
	
	
	@RequestMapping(value = "/saveNewTrBook", method = RequestMethod.POST) 
	public ResponseEntity<ReturnMessage> saveNewTrBook (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
	
		logger.debug("in  saveNewTrBook ");

		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());
		
		String bookNo = salesTrBookService.saveNewTrBook(params);
		

		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(bookNo);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    	return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectTrBookDupBulk", method = RequestMethod.GET) 
	public ResponseEntity <ReturnMessage> selectTrBookDupBulk(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		
		
		int result = salesTrBookService.selectTrBookDupBulk(params);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/saveNewTrBookBulk", method = RequestMethod.POST) 
	public ResponseEntity<ReturnMessage> saveNewTrBookBulk (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		
		logger.debug("in  saveNewTrBookBulk ");
		
		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());
		
		String reqNo = salesTrBookService.saveNewTrBookBulk(params);
		
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(reqNo);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/trBookAssignPop.do")
	public String trBookAssignPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		
		logger.debug("params ======================================>>> " + params);
		
		EgovMap detailInfo = salesTrBookService.selectTrBookDetailInfo(params);
		model.addAttribute("detailInfo", detailInfo);
		
		model.addAttribute("trBookId", params.get("trBookId"));
		
		return "sales/trBook/trBookAssignPop";
	}
	
	@RequestMapping(value = "/trBookTranSinglePop.do")
	public String trBookTranSinglePop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		
		logger.debug("params ======================================>>> " + params);
		
		EgovMap detailInfo = salesTrBookService.selectTrBookDetailInfo(params);
		model.addAttribute("detailInfo", detailInfo);
		
		model.addAttribute("trBookId", params.get("trBookId"));
		
		return "sales/trBook/trBookTranSinglePop";
	}
	
	
	
	@RequestMapping(value = "/selectTrBookByHolder")
	public ResponseEntity <EgovMap>selectTrBookByHolder(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		
		logger.debug("params ======================================>>> " + params);
		
		params.put("orderValue", "TR_BOOK_NO_START");
		List<EgovMap> resultList = salesTrBookService.selectTrBookList(params);
		
		String resultStr ="";
		
		for(int i=0; i < resultList.size(); i++){
			
			EgovMap trBookNoList = resultList.get(i);
									
			if(i ==  resultList.size()-1){
				resultStr = resultStr.concat(trBookNoList.get("trBookNo").toString());
			}else{
				resultStr = resultStr.concat(trBookNoList.get("trBookNo").toString()).concat(" & ");
			}
		}
		
		EgovMap result = new EgovMap();
		
		result.put("list", resultList);
		result.put("str", resultStr);
		
		/*// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(resultStr);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));*/
		
		return ResponseEntity.ok(result);		
	}
	
	@RequestMapping(value = "/saveAssign", method = RequestMethod.POST) 
	public ResponseEntity<EgovMap> saveAssign (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		
		logger.debug("in  saveAssign ");
		
		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());		
		
		params.put("orderValue", "TR_BOOK_NO_START");
		List<EgovMap> resultList = salesTrBookService.selectTrBookList(params);
		
		String resultStr ="";
		
		for(int i=0; i < resultList.size(); i++){
			
			EgovMap trBookNoList = resultList.get(i);
									
			if(i ==  resultList.size()-1){
				resultStr = resultStr.concat(trBookNoList.get("trBookNo").toString());
			}else{
				resultStr = resultStr.concat(trBookNoList.get("trBookNo").toString()).concat(" & ");
			}
		}
		
		EgovMap result = new EgovMap();
		String msg = "";
		String saveYn = "Y";
		
		 if (!params.get("memTypeId").equals("2") && resultList.size() >= 1 || params.get("memTypeId").equals("2") && resultList.size() >= 2)
         {
			 msg=  "* " + params.get("memTypeText").toString() + " is currently holding book - [" + resultStr + "].";
			 saveYn = "N";
         }
         else
         {
        	 salesTrBookService.saveAssign(params);  
        	 msg = "* This TR book is successfully assigned to the member.";  
        	 
         }
		
		 result.put("msg", msg);
		 result.put("saveYn", saveYn);
		
		// 결과 만들기 예.
		/*ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));*/
		
		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/saveTranSingle", method = RequestMethod.POST) 
	public ResponseEntity<ReturnMessage> saveTranSingle (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		
		logger.debug("in  saveTranSingle ");
		
		logger.debug("params =====================================>>  " + params);
		params.put("userId", sessionVO.getUserId());		

		
		String docNo = salesTrBookService.saveTranSingle(params);
		
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(docNo);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/trBookReturnPop.do")
	public String trBookRetrunPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		
		logger.debug("params ======================================>>> " + params);
		
		model.addAttribute("branch", sessionVO.getCode());
		model.addAttribute("branchName", sessionVO.getBranchName());
		
		EgovMap trBookInfo = salesTrBookService.selectTrBookInfo(params);
		model.addAttribute("trBookInfo", trBookInfo);
		
		params.put("trHolder", trBookInfo.get("trHolder"));
		EgovMap memberInfo = salesTrBookService.selectMemberInfoByCode(params);
		model.addAttribute("memberInfo", memberInfo);

		List<EgovMap> feedBackList = salesTrBookService.selectFeedBackCode();		
		model.addAttribute("feedBackList", new Gson().toJson(feedBackList));

		model.addAttribute("trBookId", params.get("trBookId"));
		
		return "sales/trBook/trBookReturnPop";
	}
	@RequestMapping(value = "/selectTrBookRetrun")
	public ResponseEntity<EgovMap>  selectTrBookRetrun(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		
		logger.debug("params ======================================>>> " + params);
		
		EgovMap result = new EgovMap();
		
		EgovMap resultData =  new EgovMap();

		params.put("trBookId", params.get("trReBookId"));
		List<EgovMap> detail = salesTrBookService.selectTrBookDetailList(params);
		List<EgovMap> detailList = new ArrayList<EgovMap>();
		
		int totalMatch = 0;
		int totalUnmatch = 0;
		int totalCancel = 0;
		int totalLost = 0;
		int totalFinance = 0;
		int totalMarketing = 0;
		
		for(EgovMap obj : detail){
			
			
			if(obj.get("isMtch").toString().equals("0") && obj.get("itmStusId").toString().equals("1") && obj.get("itmMnlPump").toString().equals("0") && !obj.get("itmUnderDcf").toString().equals("1")){
				obj.put("action", "0");
				obj.put("feedback", "");
				obj.put("remark", "");
				detailList.add(obj);
			}
			
			if(obj.get("isMtch").toString().equals("1") || obj.get("itmMnlPump").toString().equals("1")){
				totalMatch++;
			}
			if(obj.get("isMtch").toString().equals("0") && obj.get("itmStusId").toString().equals("1") && obj.get("itmMnlPump").toString().equals("0")){
				totalUnmatch++;
			}
			
			if(obj.get("itmStusId").toString().equals("10")){
				totalCancel++;
			}else if(obj.get("itmStusId").toString().equals("67")){
				totalLost++;
			}else if(obj.get("itmStusId").toString().equals("70")){
				totalFinance++;
			}else if(obj.get("itmStusId").toString().equals("72")){
				totalMarketing++;
			}
			
		}
		
		
		resultData.put("totalMatch", totalMatch);
		resultData.put("totalUnmatch", totalUnmatch);
		resultData.put("totalCancel", totalCancel);
		resultData.put("totalLost", totalLost);
		resultData.put("totalFinance", totalFinance);
		resultData.put("totalMarketing", totalMarketing);
		
		//result.put("detailList", new Gson().toJson(detailList));
		result.put("detailList", detailList);	
		result.put("resultData", resultData);

		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/updateReTrBook", method = RequestMethod.POST) 
	public ResponseEntity<EgovMap> updateReTrBook (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		
		logger.debug("in  updateReTrBook ");
		logger.debug("params =====================================>>  " + params);
		
		EgovMap result = new EgovMap();
		
		params.put("userId", sessionVO.getUserId());
		
		int cnt = salesTrBookService.selectTrBookDetails(params);
		
		if(cnt > 0){
			salesTrBookService.update_MSC0029D(params);
		}
		result.put("cnt", cnt);
		
		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/saveReTrBook", method = RequestMethod.POST) 
	public ResponseEntity<EgovMap> saveReTrBook (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		
		logger.debug("in  saveReTrBook ");
		logger.debug("params =====================================>>  " + params);
		
		EgovMap result = new EgovMap();
		
		params.put("userId", sessionVO.getUserId());
		params.put("branchCode", sessionVO.getCode());
		
		String reqNo = salesTrBookService.saveReTrBook(params);
		
		result.put("reqNo", reqNo);
		return ResponseEntity.ok(result);
	}
	
	@RequestMapping(value = "/fileUploadPop.do")
	public String fileUpload(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		logger.debug("in  fileUploadPop.do ");
		logger.debug("params =====================================>>  " + params);
		model.addAttribute("trBookItmId", params.get("trBookItmId"));
		model.addAttribute("trStusId", params.get("trStusId"));
		model.addAttribute("trAttFeedback", params.get("trReFeedback"));
		model.addAttribute("trAttTrNo", params.get("trReTrReciptNo"));
		model.addAttribute("trAttRemark", params.get("trReRemark"));
		model.addAttribute("trAttBookId", params.get("trReBookId"));
		model.addAttribute("trAttBookNo", params.get("trReTrBookNo"));
		return "sales/trBook/attachmentFileUploadPop";
	}
	
	@RequestMapping(value = "/trBookTransactionPop.do")
	public String trBookTransactionPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		return "sales/trBook/trBookTransactionPop";
	}
	
	@RequestMapping(value = "/updateReportLost", method = RequestMethod.POST) 
	public ResponseEntity<EgovMap> sampleUploadCommon(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {	
		logger.debug("in  updateReTrBook ");
		logger.debug("params =====================================>>  " + params);
		
		params.put("trBookItmId", params.get("trAttItmId"));
		params.put("trStusId", params.get("trAttStusId"));
		params.put("feedback", params.get("trAttFeedback")); 
		params.put("trNo", params.get("trAttTrNo"));  
		params.put("remark", params.get("trAttRemark"));
		params.put("trBookId", params.get("trAttBookId")); 
		params.put("trBookNo", params.get("trAttBookNo")); 
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "trBook" + File.separator + "DCF", 1024 * 1024 * 6);
		
		//EgovMap result = new EgovMap();
		
		params.put("userId", sessionVO.getUserId());
		params.put("branchId", sessionVO.getUserBranchId());
		params.put("deptId", sessionVO.getUserDeptId());	
		
		params.put("list", list);	
		
		logger.debug("list SIZE=============" + list.size());

		if(list.size() > 0){

			params.put("hasAttach", 1);
			params.put("fileName", list.get(0).getServerSubPath()+ list.get(0).getFileName());			

			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}
		
		EgovMap saveView = salesTrBookService.updateReportLost(params);		
		
		return ResponseEntity.ok(saveView);
	}
	
	@RequestMapping(value = "/trBookTranBulkPop.do")
	public String trBookTranBulk(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO){
		
		logger.debug("params ======================================>>> " + params);
		
		model.addAttribute("branchId", sessionVO.getUserBranchId());
		model.addAttribute("branchCode", sessionVO.getCode());
		
		return "sales/trBook/trBookTranBulkPop";
	}
		
	@RequestMapping(value = "/selectTrBookTranList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectTrBookTranList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {		
		
		logger.debug("in  selectTrBookTranList ");
		logger.debug("params =====================================>>  " + params);
		
		params.put("trHolder", params.get("branchFrom"));
		params.put("trHolderType", "Branch");
		params.put("stutusId", 1);

		List<EgovMap> resultList = salesTrBookService.selectTrBookList(params);
		
		return ResponseEntity.ok(resultList);
	}
	
	@RequestMapping(value="/trBookMgmtSummaryListingPop.do")
	public String trBookMgmtSummaryListingPop(){
		
		return "sales/trBook/trBookMgmtSummaryListingPop";
	}
	
	@RequestMapping(value="/trBookMgmtLostReportListPop.do")
	public String trBookMgmtLostReportListPop(){
		
		return "sales/trBook/trBookMgmtLostReportListPop";
	}
}
