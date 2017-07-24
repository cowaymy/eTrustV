package com.coway.trust.web.common;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.config.DatabaseDrivenMessageSource;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovResourceCloseHelper;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class CommonController {

	private static final Logger logger = LoggerFactory.getLogger(CommonController.class);
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private DatabaseDrivenMessageSource dbMessageSource;
	
	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("groupCode : {}", params.get("groupCode"));

		List<EgovMap> codeList = commonService.selectCodeList(params);
		return ResponseEntity.ok(codeList);
	}
	
	
/**************** Account Code Management *****************/	
	
	@RequestMapping(value = "/accountCode.do")
	public String listAccountCode(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return "/common/accountCodeManagement";
	}	
	
	@RequestMapping(value = "/selectAccountCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAccountCodeList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("accountCdId : {}", params.get("accountCdId"));

		List<EgovMap> accountCodeList = commonService.getAccountCodeList(params);
		
		return ResponseEntity.ok(accountCodeList);

	}
/*	
	@RequestMapping(value = "/getAccountCodeCount.do", method = RequestMethod.GET)
	public ResponseEntity<Integer> getAccountCodeCount(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("popUpAccCode : {}", params.get("popUpAccCode"));
		
		int accountCodeCount = commonService.getAccCodeCount(params);
		
		logger.debug("getCdCnt : {}", accountCodeCount);
		
		return ResponseEntity.ok(accountCodeCount);
		
	}*/
	
	
	/**
	 * POPUP 화면 호출.
	 */
	@RequestMapping(value = "/accountCodeEditPop.do")
	public String accountCodeUpdPop(@RequestParam Map<String, Object> params, ModelMap model) 
	{
		//{paramAccCode=1000/000, paramAccDesc=FIXED ASSTES AT COST, paramSapAccCode=, parmIsPayCash=1, parmIsPayChq=0, parmIsPayOnline=0, parmIsPayCrc=1, accId=, accCode=, accDesc=, sapAccCode=, accStusId=1, paymentCd=, isPop=true}
		logger.debug(" Edit InputParams : {}", params.toString() );

		// popup 화면으로 넘길 데이터.
		model.addAttribute("inputParams", params);

		// 호출될 화면
		return "/common/accountCodeManagementPop";
	}
	
	@RequestMapping(value = "/accountCodeAddPop.do")
	public String accountCodeAddPop(@RequestParam Map<String, Object> params, ModelMap model) 
	{
		//{paramAccCode=1000/000, paramAccDesc=FIXED ASSTES AT COST, paramSapAccCode=, parmIsPayCash=1, parmIsPayChq=0, parmIsPayOnline=0, parmIsPayCrc=1, accId=, accCode=, accDesc=, sapAccCode=, accStusId=1, paymentCd=, isPop=true}
		
		//String flag = "ADD";		
		//HashMap<String, Object> paramData = new HashMap<String, Object>();		
		//((Map<String, Object>) paramData).put("parmAddEditFlag", flag);		
		//model.addAttribute("InputParams", paramData);
	    				
		//Add InputParams : {InputParams={parmAddEditFlag=ADD}}
		logger.debug(" Add InputParams : {}", model.toString() );
		
		
		// 호출될 화면
		return "/common/accountCodeManagementPop";
	}	
	
	/**
	 * ACCOUNT CODE INSERT
	 */
	@RequestMapping(value = "/insertAccount.do")
	public ResponseEntity<ReturnMessage> insertAccountCode(@RequestBody Map<String, Object> params, ModelMap model) 
	{
		// InputAccountCode Params : {popUpAccCodeId=729, popUpSaveFlag=EDIT, popUpAccCode=667700, popUpSapAccCode=, popUpAccDesc=667700, popUpIsPayCash=on, popUpIsPayChq=on, popUpIsPayOnline=on, popUpIsPayCrc=on, address1=, address2=, address3=, mcountry=, mstate=, marea=, mpostcd=, tel1=, tel2=}
		logger.debug(" InputAccountCode Params : {}", params.toString() );
		ReturnMessage message = new ReturnMessage();
		
		if (!"EDIT".equals(params.get("popUpSaveFlag")) )
		{
			int accountCodeCount = commonService.getAccCodeCount(params);
			
			if(accountCodeCount > 0){
				message.setCode(AppConstants.FAIL);
				message.setMessage("CODE [" + params.get("popUpAccCode") + "] Exists Already.");
				return ResponseEntity.ok(message);
			}
		}
	
		int user=99999;
		
		((Map<String, Object>) params).put("crtUserId", user);
		((Map<String, Object>) params).put("updUserId", user);
		
		if ("on".equals( String.valueOf(params.get("popUpIsPayCash"))))	
		{
			params.put("popUpIsPayCash", 1);
		}
		else
		{
			params.put("popUpIsPayCash", 0);
		}
		
		if ("on".equals( String.valueOf(params.get("popUpIsPayChq"))))	
		{
			params.put("popUpIsPayChq", 1);
		}
		else
		{
			params.put("popUpIsPayChq", 0);
		}
		
		if ("on".equals( String.valueOf(params.get("popUpIsPayOnline"))))	
		{
			params.put("popUpIsPayOnline", 1);
		}
		else
		{
			params.put("popUpIsPayOnline", 0);
		}
		
		if ("on".equals( String.valueOf(params.get("popUpIsPayCrc"))))	
		{
			params.put("popUpIsPayCrc", 1);
		}
		else
		{
			params.put("popUpIsPayCrc", 0);
		}

		logger.debug(" ParamsChange : {}", params.toString() );
		
		
		int cnt = commonService.mergeAccountCode(params);
		//int cnt = commonService.insertAccountCode(params);
		//ParamsChange : {popUpAccCode=111, popUpSapAccCode=222, popUpAccDesc=3333, popUpIsPayCash=1, popUpIsPayCrc=1, address1=, address2=, address3=, mcountry=, tel1=, tel2=, popUpIsPayChq=0, popUpIsPayOnline=0}
		
		// 호출될 화면
		// 결과 만들기 예.
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}	
	
	
/**************** General Code Management *****************/	
	
	@RequestMapping(value = "/generalCode.do")
	public String listCommCode(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return "/common/generalCodeManagement";
	}
	
	@RequestMapping(value = "/selectMstCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeMstList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("commCodeMstId : {}", params.get("mstCdId"));

		List<EgovMap> mstCommCodeList = commonService.getMstCommonCodeList(params);
		
		return ResponseEntity.ok(mstCommCodeList);

	}
	
	@RequestMapping(value = "/selectDetailCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeDetailList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("commDetailDisabled : {}", params.get("mstDisabled"));
		logger.debug("commDetailCodeMstId : {}", params.get("mstCdId"));
		logger.debug("commDetailDisabled : {}", params.get("dtailDisabled"));
		
		List<EgovMap> mstCommDetailCodeList = commonService.getDetailCommonCodeList(params);
		
		return ResponseEntity.ok(mstCommDetailCodeList);
		
	}

	@RequestMapping(value = "/unauthorized.do")
	public String unauthorized(@RequestParam Map<String, Object> params, ModelMap model) {
		return "/error/unauthorized";
	}
	
	@RequestMapping(value = "/exportGrid.do")
	public void export(HttpServletRequest request, HttpServletResponse response) {
		// AUIGrid 가 xlsx, csv, xml 등의 형식을 작성하여 base64 로 인코딩하여 data 파라메터로 post 요청을 합니다.
		// 해당 서버에서는 base64 로 인코딩 된 데이터를 디코드하여 다운로드 가능하도록 붙임으로 마무리합니다.
		// 참고로 org.apache.commons.codec.binary.Base64 클래스 사용을 위해는 commons-codec-1.4.jar 파일이 필요합니다.

		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

		String data = request.getParameter("data"); // 파라메터 data
		String extension = request.getParameter("extension"); // 파라메터 확장자
		String reqFileName = request.getParameter("filename"); // 파라메터 파일명

		byte[] dataByte = Base64.decodeBase64(data.getBytes()); // 데이터 base64 디코딩

		// csv 를 엑셀에서 열기 위해서는 euc-kr 로 작성해야 함.
		try {
			if (extension.equals("csv")) {
				String sting = new String(dataByte, "utf-8");
				outputStream.write(sting.getBytes("euc-kr"));
			} else {
				outputStream.write(dataByte);
			}
		} catch (UnsupportedEncodingException e) {
			throw new ApplicationException(e);
		} catch (IOException e) {
			throw new ApplicationException(e);
		} finally {
			EgovResourceCloseHelper.close(outputStream);
		}

		String fileName = "export." + extension; // 다운로드 될 파일명

		if (CommonUtils.isNotEmpty(reqFileName)) {
			fileName = reqFileName + "." + extension;
		}

		response.reset();
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		response.setHeader("Content-Length", String.valueOf(outputStream.size()));

		ServletOutputStream sos = null;
		try {
			sos = response.getOutputStream();
			sos.write(outputStream.toByteArray());
			sos.flush();
			sos.close();
		} catch (IOException e) {
			throw new ApplicationException(e);
		} finally {
			EgovResourceCloseHelper.close(sos);
		}
	}

	@RequestMapping(value = "/db-messages/reload.do")
	public void reload(@RequestParam Map<String, Object> params, ModelMap model) {
		dbMessageSource.reload();
	}
	
	@RequestMapping(value = "/saveGeneralCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommissionGrid(@RequestBody Map<String, ArrayList<Object>> params,	Model model) 
	{
		List<Object> udtList = params.get(AppConstants.AUIGrid_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
					// 조회.
			int cnt=0;
			if(addList.size()>0)
			{
				cnt=commonService.addCommCodeGrid(addList);
			}
			if(udtList.size()>0)
			{   
				cnt=commonService.udtCommCodeGrid(udtList);
			}
/*			if(delList.size()>0)
			{
				cnt=commonService.delCommCodeGrid(delList);
			}*/


		// 콘솔로 찍어보기
		logger.info("CommCd_수정 : {}", udtList.toString());
		logger.info("CommCd_추가 : {}", addList.toString());
		logger.info("CommCd_삭제 : {}", delList.toString());
		logger.info("CommCd_카운트 : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}	
	
	@RequestMapping(value = "/saveDetailCommCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommDetailGrid(@RequestBody Map<String, ArrayList<Object>> params,	Model model) 
	{
		List<Object> udtList = params.get(AppConstants.AUIGrid_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList
		
		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		// 조회.
		int cnt=0;
		if(addList.size()>0)
		{
			cnt=commonService.addDetailCommCodeGrid(addList);
		}
		if(udtList.size()>0)
		{   
			cnt=commonService.udtDetailCommCodeGrid(udtList);
		}
		/*			if(delList.size()>0)
			{
				cnt=commonService.delCommCodeGrid(delList);
			}
		*/

		// 콘솔로 찍어보기
		logger.info("DetailCommCd_수정 : {}", udtList.toString());
		logger.info("DetailCommCd_추가 : {}", addList.toString());
		logger.info("DetailCommCd_삭제 : {}", delList.toString());
		logger.info("DetailCommCd_카운트 : {}", cnt);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}	
	
	@RequestMapping(value = "/selectBranchCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranchCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("groupCode : {}", params.get("groupCode"));

		List<EgovMap> codeList = commonService.selectBranchList(params);
		return ResponseEntity.ok(codeList);
	}
	
	/**
	 * Use Map and Edit Grid Insert,Update,Delete
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
/*	@RequestMapping(value = "/saveGeneralCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveGeneralCodeGrid2222(@RequestBody Map<String, Object> params,	Model model) 
	{
		SessionVO sessionVO =  new SessionVO(); //sessionHandler.getCurrentSessionInfo();
		sessionVO.setId("7777");
		params.put(AppConstants.SESSION_INFO, sessionVO);
		commonService.saveCodes(params);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}	*/
	
	/**
	 * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/getAccountList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getAccountList(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> resultList = commonService.getAccountList(params);
		return ResponseEntity.ok(resultList);
	}
	
	 /**
	 * Branch ID로 User 정보 조회
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/getUsersByBranch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getUsersByBranch(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> resultList = commonService.getUsersByBranch(params);
		return ResponseEntity.ok(resultList);
	}
	
	
	@RequestMapping(value = "/selectAddrSelCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAddrSelCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("groupCode : {}", params.get("groupCode"));
		
		List<EgovMap> codeList = commonService.selectAddrSelCode(params);
		return ResponseEntity.ok(codeList);
	}
	
	@RequestMapping(value = "/selectProductCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> codeList = commonService.selectProductCodeList();
		return ResponseEntity.ok(codeList);
	}
	@RequestMapping(value = "/selectInStckSelCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectInStckSelCodeList(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> codeList = commonService.selectInStckSelCodeList(params);
		logger.info("selectInStckSelCodeList: {}", codeList.toString());
		return ResponseEntity.ok(codeList);
	}

	
}
