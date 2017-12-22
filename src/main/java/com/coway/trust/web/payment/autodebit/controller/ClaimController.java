package com.coway.trust.web.payment.autodebit.controller;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.coway.trust.web.common.claim.FileInfoVO;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.biz.payment.autodebit.service.ClaimService;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.claim.FormDef;
import com.coway.trust.web.common.claim.ClaimFileALBHandler;
import com.coway.trust.web.common.claim.ClaimFileBSNHandler;
import com.coway.trust.web.common.claim.ClaimFileCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileFPXHandler;
import com.coway.trust.web.common.claim.ClaimFileHLBBHandler;
import com.coway.trust.web.common.claim.ClaimFileMBBHandler;
import com.coway.trust.web.common.claim.ClaimFileMyClearHandler;
import com.coway.trust.web.common.claim.ClaimFileNewALBHandler;
import com.coway.trust.web.common.claim.ClaimFilePBBHandler;
import com.coway.trust.web.common.claim.ClaimFileRHBHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class ClaimController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimController.class);

	@Value("${autodebit.file.upload.path}")
	private String filePath;

	@Value("${autodebit.email.receiver}")
	private String emailReceiver;

	@Autowired
	private AdaptorService adaptorService;

	@Resource(name = "claimService")
	private ClaimService claimService;
	
	@Autowired
	private CsvReadComponent csvReadComponent;

	@Autowired
	private LargeExcelService largeExcelService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	private String[] claimFileColumns = new String[] { "bankDtlId", "bankDtlCtrlId", "salesOrdId", "bankDtlDrDt",
			"bankDtlDrBankTypeId", "bankDtlDrAccNo", "bankDtlDrName", "bankDtlAmt", "taskId", "crtUserId",
			"crtDt", "updUserId", "updDt", "bankDtlDrNric", "bankDtlRenStus", "svcCntrctId", "bankDtlBankId",
			"bankAppv", "bankDtlApprDt", "bic", "bankDtlFpxId", "fpxCode", "salesOrdNo", "bankDtlRptAmt",
			"bankDtlRenAmt", "bankDtlCrcExpr", "srvCntrctRefNo", "billNo", "cntrctNOrdNo" };

	/******************************************************
	 * Claim List
	 *****************************************************/
	/**
	 * ClaimList 초기화 화면
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initClaimList.do")
	public String initClaimList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/autodebit/claimList";
	}

	/**
	 * Claim List List(Master Grid) 조회
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectClaimList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectClaimList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 조회.
		List<EgovMap> resultList = claimService.selectClaimList(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}

	/**
	 * Claim Master By Id (Master Grid) 조회 -
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectClaimMasterById.do", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectClaimMasterById(@RequestParam Map<String, Object> params, ModelMap model) {

		EgovMap returnMap = null;
		// 조회.
		List<EgovMap> resultList = claimService.selectClaimList(params);

		if (resultList != null && resultList.size() > 0) {
			returnMap = resultList.get(0);
		} else {
			returnMap = new EgovMap();
		}

		// 조회 결과 리턴.
		return ResponseEntity.ok(returnMap);
	}

	/**
	 * Claim Result Deactivate 처리
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updateDeactivate.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updateDeactivate(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());
		// 처리.
		claimService.updateDeactivate(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);

	}

	/**
	 * Claim Result - Fail Deduction SMS 재발송 처리
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/sendFaileDeduction.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> sendFaileDeduction(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());
		// 처리.
		claimService.sendFaileDeduction(params);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);

	}

	/**
	 * Claim Result Upload File 처리
	 * 
	 * @param params
	 * @param model
	 * @return
	 * @RequestParam Map<String, Object> params
	 */
	@RequestMapping(value = "/updateClaimResultItem.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateClaimResultItem(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) {

		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		List<Object> resultItemList = new ArrayList<Object>();
		Map<String, Object> uploadMap = null;
		String refNo = "";
		int totalSuccess = 0;
		int totalFail = 0;

		// 폼객체 처리.
		Map<String, Object> claimMap = (Map<String, Object>) formList.get(0);

		// 파일로 입력받은 그리드 데이터
		if (gridList.size() > 0) {

			Map<String, Object> hm = null;

			for (Object map : gridList) {
				hm = (HashMap<String, Object>) map;

				// 첫번째 값이 없으면 skip
				if (hm.get("0") == null || String.valueOf(hm.get("0")).equals("")
						|| String.valueOf(hm.get("0")).trim().length() < 1) {
					continue;
				}

				refNo = (String.valueOf(hm.get("0"))).trim().length() < 7 ? "0" + (String.valueOf(hm.get("0"))).trim()
						: (String.valueOf(hm.get("0"))).trim();

				uploadMap = new HashMap<String, Object>();
				uploadMap.put("refNo", refNo);
				uploadMap.put("refCode", (String.valueOf(hm.get("1"))).trim());
				uploadMap.put("id", (String.valueOf(claimMap.get("ctrlId"))).trim());

				if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))
						|| "2".equals(String.valueOf(claimMap.get("bankId")))
						|| "3".equals(String.valueOf(claimMap.get("bankId")))) {
					uploadMap.put("itemId", (String.valueOf(hm.get("2"))).trim());
				} else {
					uploadMap.put("itemId", "");
				}

				resultItemList.add(uploadMap);

				// message 처리를 위한 값 세팅
				if ("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
					if ("".equals(String.valueOf(uploadMap.get("refCode")))) {
						totalSuccess++;
					}
					if (!"".equals(String.valueOf(uploadMap.get("refCode")))) {
						totalFail++;
					}
				} else if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))
						|| "134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
					if ("00".equals(String.valueOf(uploadMap.get("refCode")))) {
						totalSuccess++;
					}
					if (!"00".equals(String.valueOf(uploadMap.get("refCode")))) {
						totalFail++;
					}
				}
			}
		}

		claimMap.put("totalItem", resultItemList.size());
		claimMap.put("totalSuccess", totalSuccess);
		claimMap.put("totalFail", totalFail);

		// 데이터 등록
		claimService.updateClaimResultItem(claimMap, resultItemList);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(claimMap);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);
	}
	
	
	
	
	
	/**
	 * Claim Result Upload File 처리 - 새로운 방식으로....
	 * 
	 * @param params
	 * @param model
	 * @return
	 * @RequestParam Map<String, Object> params
	 */
	@RequestMapping(value = "/updateClaimResultItemBulk.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateClaimResultItemBulk(MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("ctrlId : {}  ", request.getParameter("ctrlId"));
		LOGGER.debug("ctrlIsCrc : {}  ", request.getParameter("ctrlIsCrc"));
		LOGGER.debug("bankId : {}  ", request.getParameter("bankId"));
		
		//Master 정보 세팅
		Map<String, Object> claimMap = new HashMap<String, Object>();
		claimMap.put("ctrlId",request.getParameter("ctrlId"));
		claimMap.put("ctrlIsCrc",request.getParameter("ctrlIsCrc"));
		claimMap.put("bankId",request.getParameter("bankId"));
		
		//CVS 파일 세팅
		Map<String, MultipartFile> fileMap = request.getFileMap();		
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<ClaimResultUploadVO> vos = csvReadComponent.readCsvToList(multipartFile,true ,ClaimResultUploadVO::create);
		
		//CVS 파일 객체 세팅 
		Map<String, Object> cvsParam = new HashMap<String, Object>();				
		cvsParam.put("voList", vos);
		cvsParam.put("userId", sessionVO.getUserId());
		
		EgovMap resultMap = claimService.updateClaimResultItemBulk(claimMap, cvsParam);
				
		
		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
    	message.setMessage("Saved Successfully");
    
    	return ResponseEntity.ok(message);
	}

	/**
	 * Claim Result Update LIVE 처리
	 * 
	 * @param params
	 * @param model
	 * @return
	 * @RequestParam Map<String, Object> params
	 */
	@RequestMapping(value = "/updateClaimResultLive.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateClaimResultLive(@RequestBody Map<String, ArrayList<Object>> params,
			Model model, SessionVO sessionVO) {

		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		// 폼객체 처리.
		Map<String, Object> claimMap = (Map<String, Object>) formList.get(0);
		claimMap.put("userId", sessionVO.getUserId());

		// 데이터 수정
		claimService.updateClaimResultLive(claimMap);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(claimMap);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);
	}

	/**
	 * Claim Result Update NEXT DAY 처리
	 * 
	 * @param params
	 * @param model
	 * @return
	 * @RequestParam Map<String, Object> params
	 */
	@RequestMapping(value = "/updateClaimResultNextDay.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateClaimResultNextDay(@RequestBody Map<String, ArrayList<Object>> params,
			Model model, SessionVO sessionVO) {

		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		// 폼객체 처리.

		Map<String, Object> claimMap = (Map<String, Object>) formList.get(0);
		claimMap.put("userId", sessionVO.getUserId());

		// 데이터 수정
		claimService.updateClaimResultNextDay(claimMap);

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(claimMap);
		message.setMessage("Saved Successfully");

		return ResponseEntity.ok(message);
	}

	/**
	 * Generate New Claim 처리
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/generateNewClaim.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> generateNewClaim(@RequestBody Map<String, ArrayList<Object>> params,
			Model model, SessionVO sessionVO) {

		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		Map<String, Object> returnMap = new HashMap<String, Object>();
		Map<String, Object> searchMap = null;
		String returnCode = "";

		// form 객체 값을 담을 Map
		Map<String, Object> claim = new HashMap<String, Object>();

		// form 객체 데이터 세팅
		if (formList.size() > 0) {
			formList.forEach(obj -> {
				Map<String, Object> map = (Map<String, Object>) obj;
				claim.put((String) map.get("name"), map.get("value"));
			});
		}
		// 검색 파라미터 확인.(화면 Form객체 입력값)
		LOGGER.debug("new_claimType : {}", claim.get("new_claimType"));
		LOGGER.debug("new_claimDay : {}", claim.get("new_claimDay"));
		LOGGER.debug("new_issueBank : {}", claim.get("new_issueBank"));
		LOGGER.debug("new_debitDate : {}", claim.get("new_debitDate"));

		// HasActiveBatch : 동일한 bankId, Claim Type 에 해당하는 active 건이 있는지 확인한다.
		searchMap = new HashMap<String, Object>();
		searchMap.put("issueBank", claim.get("new_issueBank"));
		searchMap.put("claimType", claim.get("new_claimType"));
		searchMap.put("status", "1");

		List<EgovMap> isActiveBatchList = claimService.selectClaimList(searchMap);

		// Active인 배치가 있는 경우
		if (isActiveBatchList.size() > 0) {
			returnCode = "IS_BATCH";
			returnMap = (Map<String, Object>) isActiveBatchList.get(0);
		} else {

			String isCRC = "131".equals((String.valueOf(claim.get("new_claimType")))) ? "1"
					: "132".equals((String.valueOf(claim.get("new_claimType")))) ? "0" : "134";
			String inputDate = CommonUtils.changeFormat(String.valueOf(claim.get("new_debitDate")), "dd/MM/yyyy",
					"yyyyMMdd");
			String claimDay = CommonUtils.nvl(String.valueOf(claim.get("new_claimDay")));
			String bankId = CommonUtils.nvl(String.valueOf(claim.get("new_issueBank")));

			claim.put("new_claimType", isCRC);
			claim.put("new_debitDate", inputDate);
			claim.put("new_claimDay", claimDay);
			claim.put("new_issueBank", bankId);
			claim.put("userId", sessionVO.getUserId());

			claimService.createClaim(claim); // 프로시저 함수 호출
			List<EgovMap> resultMapList = (List<EgovMap>) claim.get("p1"); // 결과 뿌려보기 : 프로시저에서 p1이란 key값으로 객체를 반환한다.

			if (resultMapList.size() > 0) {
				// 프로시저 결과 Map
				returnMap = (Map<String, Object>) resultMapList.get(0);

				// Calim Master 및 Detail 조회
				// EgovMap claimMasterMap = claimService.selectClaimById(returnMap);
				// List<EgovMap> claimDetailList = claimService.selectClaimDetailById(returnMap);

				try {
					// 파일 생성하기
					// this.createClaimFileMain(claimMasterMap,claimDetailList);
					returnCode = "FILE_OK";
				} catch (Exception e) {
					returnCode = "FILE_FAIL";
				}
			} else {
				returnCode = "FAIL";
			}
		}

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(returnCode);
		message.setData(returnMap);
		message.setMessage("Enrollment successfully saved. \n Enroll ID : ");

		return ResponseEntity.ok(message);

	}

	/**
	 * Claim List - SMS deduction 팝업 리스트 조회
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectFailClaimDetailList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectFailClaimDetailList(@RequestParam Map<String, Object> params,
			Model model) {
		// 조회.
		List<EgovMap> detailList = claimService.selectFailClaimDetailList(params);

		// 조회 결과 리턴.
		return ResponseEntity.ok(detailList);
	}	
	
	/******************************************************
	 * Claim List - Schedule Claim Batch Pop-up  
	 *****************************************************/	
	/**
	 * Claim List - Schedule Claim Batch Pop-up 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initScheduleClaimBatchPop.do")
	public String initScheduleClaimBatchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/autodebit/scheduleClaimBatchPop";
	}
	
	/**
	 * Claim List - Schedule Claim Batch Pop-up 리스트 조회 
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectScheduleClaimBatchPop.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScheduleClaimBatchPop(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		String[] status = request.getParameterValues("status");
		params.put("status", status);
		
		String[] claimType = request.getParameterValues("claimType");
		params.put("claimType", claimType);
		
		String[] issueBank = request.getParameterValues("issueBank");
		params.put("issueBank", issueBank);
		
		String[] claimDay = request.getParameterValues("claimDay");
		params.put("claimDay", claimDay);
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		List<EgovMap> resultList = claimService.selectScheduleClaimBatchPop(params);
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initScheduleClaimSettingPop.do")
	public String initScheduleClaimSettingPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/autodebit/scheduleClaimSettingPop";
	}
	
	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회 
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectScheduleClaimSettingPop.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScheduleClaimSettingPop(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		List<EgovMap> resultList = claimService.selectScheduleClaimSettingPop(params);
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회 
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/isScheduleClaimSettingPop.do", method = RequestMethod.GET)
	public ResponseEntity<Integer> isScheduleClaimSettingPop(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("params : {} ", params);	
		// 조회.
		int resultCnt = claimService.isScheduleClaimSettingPop(params);
    
		// 조회 결과 리턴.
		return ResponseEntity.ok(resultCnt);
	}
	
	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 저장 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveScheduleClaimSettingPop.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> saveScheduleClaimSettingPop(@RequestParam Map<String, Object> params,
    		Model model, SessionVO sessionVO) {
		
		params.put("userId", sessionVO.getUserId());
    	// 처리.
		claimService.saveScheduleClaimSettingPop(params);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);    	
    	message.setMessage("Saved Successfully");
    	
    	return ResponseEntity.ok(message);
		
    }
	
	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 삭제 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/removeScheduleClaimSettingPop.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> removeScheduleClaimSettingPop(@RequestParam Map<String, Object> params,
    		Model model, SessionVO sessionVO) {
		
		params.put("userId", sessionVO.getUserId());
    	// 처리.
		claimService.removeScheduleClaimSettingPop(params);
		
		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);    	
    	message.setMessage("Saved Successfully");
    	
    	return ResponseEntity.ok(message);
		
    }
	
	/******************************************************
	 * *****************************************************
	 * 
	 * Claim List - Create File
	 *    
	 ******************************************************
	 ******************************************************/	
	/**
	 * Claim Create File 처리
	 * 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/createClaimFile.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> createClaimFile(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) throws Exception {

		List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		// Calim Master 데이터 조회
		Map<String, Object> map = (Map<String, Object>) formList.get(0);
		EgovMap claimMap = claimService.selectClaimById(map);
		
		
		// 파일 생성하기
		if ("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
			// ALB
			if ("2".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
				this.createClaimFileALB(claimMap);
				this.createClaimFileNewALB(claimMap);
			}

            // CIMB
            if ("3".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
            	this.createClaimFileCIMB(claimMap);
            }
            
            // HLBB
            if ("5".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
            	this.createClaimFileHLBB(claimMap);
            }
            
            // MBB
            if ("21".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
            	this.createClaimFileMBB(claimMap);
            }
            
            // PBB
            if ("6".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
            	this.createClaimFilePBB(claimMap);
            }
            
            // RHB
            if ("7".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
            	this.createClaimFileRHB(claimMap);
            }
            
            // BSN
            if ("9".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
            	this.createClaimFileBSN(claimMap);
            }
            
            // My Clear
            if ("46".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
            	this.createClaimFileMyClear(claimMap);
            }		
		} else if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
			
			//10000건 단위로 추출하기 위해 전체 건수 조회
			int totRowCount = claimService.selectClaimDetailByIdCnt(map);
			int pageCnt = (int) Math.round(Math.ceil(totRowCount / 10000.0));
			
			if (pageCnt > 0){
				for(int i = 1 ; i <= pageCnt ; i++){					
					claimMap.put("pageNo", i);
					claimMap.put("rowCount", 10000);
					this.createClaimFileCrcCIMB(claimMap);
				}
			}
			//this.createClaimFileCrcCIMB(claimMap);
			
		} else if ("134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
			this.createClaimFileFPX(claimMap);
		}
		
		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}
	
	public void createClaimFileALB(EgovMap claimMap) throws Exception {
		
		ClaimFileALBHandler downloadHandler = null;
		String sFile;
		String ctrlBatchDt;
		String inputDate;

		try {
			ctrlBatchDt = (String) claimMap.get("ctrlBatchDt");
			inputDate = CommonUtils.nvl(ctrlBatchDt).equals("") ? "1900-01-01" : ctrlBatchDt;
			sFile = "ALB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd") + "B01.txt";

			downloadHandler = getTextDownloadALBHandler(sFile, claimFileColumns, null, filePath, "/ALB/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFileALB(claimMap, downloadHandler);
			downloadHandler.writeFooter();
			

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/ALB/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("ALB Auto Debit Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
	}

	private ClaimFileALBHandler getTextDownloadALBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileALBHandler(excelDownloadVO, params);
	}
	
	
	
	/**
	 * ALB NEW - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileNewALB(EgovMap claimMap) throws Exception {
		
		ClaimFileNewALBHandler downloadHandler = null;
		String todayDate;
		String sFile;
		
		try {			
			todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
			sFile = "AD_Billing_" + todayDate + ".txt";
			
			downloadHandler = getTextDownloadNewALBHandler(sFile, claimFileColumns, null, filePath, "/ALB/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFileNewALB(claimMap, downloadHandler);
			downloadHandler.writeFooter();			

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/ALB/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("New ALB Auto Debit Claim File - Batch Date : " + CommonUtils.nvl(claimMap.get("ctrlBatchDt")));
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);

	}
	
	private ClaimFileNewALBHandler getTextDownloadNewALBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileNewALBHandler(excelDownloadVO, params);
	}
	
	/**
	 * CIMB - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileCIMB(EgovMap claimMap) throws Exception {
		
		ClaimFileCIMBHandler downloadHandler = null;
		String sFile;		
		String inputDate;

		try {
			inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");
			sFile = "CIMB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd") + "B01.dat";
			
			downloadHandler = getTextDownloadCIMBHandler(sFile, claimFileColumns, null, filePath, "/CIMB/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFileCIMB(claimMap, downloadHandler);
			downloadHandler.writeFooter();

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/CIMB/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("CIMB Auto Debit Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);		
	}
	
	private ClaimFileCIMBHandler getTextDownloadCIMBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileCIMBHandler(excelDownloadVO, params);
	}
	
	/**
	 * HLBB - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileHLBB(EgovMap claimMap) throws Exception {
		
		ClaimFileHLBBHandler downloadHandler = null;
		String sFile;
		String inputDate;

		try {
			inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");
			sFile = "EPY1000991_" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyyyy") + ".csv";
			
			downloadHandler = getTextDownloadHLBBHandler(sFile, claimFileColumns, null, filePath, "/HLBB/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFileHLBB(claimMap, downloadHandler);
			downloadHandler.writeFooter();

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/HLBB/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("HLBB Auto Debit Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
		
		
	}
	
	private ClaimFileHLBBHandler getTextDownloadHLBBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileHLBBHandler(excelDownloadVO, params);
	}
	
	
	/**
	 * MBB - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileMBB(EgovMap claimMap) throws Exception {
		
		ClaimFileMBBHandler downloadHandler = null;
		String sFile;
		String ctrlBatchDt;
		String inputDate;

		try {
			ctrlBatchDt = (String) claimMap.get("ctrlBatchDt");
			inputDate = CommonUtils.nvl(ctrlBatchDt).equals("") ? "1900-01-01" : ctrlBatchDt;
			sFile = "ADSACC.txt";

			downloadHandler = getTextDownloadMBBHandler(sFile, claimFileColumns, null, filePath, "/MMB/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFileMBB(claimMap, downloadHandler);
			downloadHandler.writeFooter();
			

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/MMB/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("MBB Auto Debit Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
	}
	
	
	private ClaimFileMBBHandler getTextDownloadMBBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileMBBHandler(excelDownloadVO, params);
	}
	
	/**
	 * PBB - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFilePBB(EgovMap claimMap) throws Exception {
		
		ClaimFilePBBHandler downloadHandler = null;
		String sFile;
		String inputDate;

		try {			
			inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");			
			sFile = "WCBPBB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyyyy") + "01.DIF";
			
			downloadHandler = getTextDownloadPBBHandler(sFile, claimFileColumns, null, filePath, "/PBB/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFilePBB(claimMap, downloadHandler);
			downloadHandler.writeFooter();			

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/PBB/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("PBB Auto Debit Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
		

		/*********************************************
		 * Second file
		 *********************************************/
		String sFile2nd = "WCBPBB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyyyy") + "01.DTR";

		// 파일 디렉토리
		File file2nd = new File(filePath + "/PBB/ClaimBank/" + sFile2nd);

		// 디렉토리 생성
		if (!file2nd.getParentFile().exists()) {
			file2nd.getParentFile().mkdirs();
		}

		FileWriter fileWriter2nd = new FileWriter(file2nd);
		BufferedWriter out2nd = new BufferedWriter(fileWriter2nd);

		String count = StringUtils.leftPad(String.valueOf( Integer.parseInt(String.valueOf(claimMap.get("ctrlTotItm")))  + 2), 6, " ");
		String iTotalAmtStr = StringUtils
				.leftPad(CommonUtils.getNumberFormat(String.valueOf(((java.math.BigDecimal) claimMap.get("ctrlBillAmt")).doubleValue()), "###,###,###.00"), 13, " ");

		StringBuffer sb = new StringBuffer();

		sb.append("                                                         PAGE: 1").append("\n");
		sb.append("                                                         REPORT DATE: "
				+ CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "dd/MM/yyyy")).append("\n");
		sb.append("").append("\n");
		sb.append("                           WOONGJIN COWAY (M) SDN BHD").append("\n");
		sb.append("                   TRANSMITTAL REPORT OF DIRECT DEBIT RECORDS").append("\n");
		sb.append("                              FOR PUBLIC BANK BERHAD").append("\n");
		sb.append("").append("\n");
		sb.append("").append("\n");
		sb.append("DEDUCTION DATE: " + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "dd/MM/yyyy")).append("\n");
		sb.append("").append("\n");
		sb.append("           COUNT       AMOUNT").append("\n");
		sb.append("          -------------------").append("\n");
		sb.append("TOTAL:    " + count + iTotalAmtStr).append("\n");
		sb.append("").append("\n");

		out2nd.write(sb.toString());
		out2nd.newLine();
		out2nd.flush();

		out2nd.close();
		fileWriter2nd.close();

		// E-mail 전송하기
		EmailVO email2 = new EmailVO();

		email2.setTo(emailReceiver);
		email2.setHtml(false);
		email2.setSubject("PBB Auto Debit Claim File - Batch Date : " + CommonUtils.nvl(claimMap.get("ctrlBatchDt")));
		email2.setText("Please find attached the claim file for your kind perusal.");
		email2.addFile(file2nd);

		adaptorService.sendEmail(email2, false);
	}
	
	private ClaimFilePBBHandler getTextDownloadPBBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFilePBBHandler(excelDownloadVO, params);
	}
	
	
	/**
	 * RHB - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileRHB(EgovMap claimMap) throws Exception {
		ClaimFileRHBHandler downloadHandler = null;
		String inputDate;
		String sFile;
		String todayDate;
		
		try {
			inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");
			todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
			sFile = "AB_00035_Datafile_" + todayDate + "_001.txt";

			downloadHandler = getTextDownloadRHBHandler(sFile, claimFileColumns, null, filePath, "/RHB/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFileRHB(claimMap, downloadHandler);
			downloadHandler.writeFooter();
			

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/RHB/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("RHB Auto Debit Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
		
	}
	
	
	private ClaimFileRHBHandler getTextDownloadRHBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileRHBHandler(excelDownloadVO, params);
	}
	
	
	/**
	 * BSN - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileBSN(EgovMap claimMap) throws Exception {

		ClaimFileBSNHandler downloadHandler = null;
		String sFile;
		String todayDate;
		String inputDate;

		try {
			
			inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");
			todayDate = CommonUtils.getNowDate();
			sFile = "BSN" + todayDate + "B01.txt";

			downloadHandler = getTextDownloadBSNHandler(sFile, claimFileColumns, null, filePath, "/BSN/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFileBSN(claimMap, downloadHandler);
			downloadHandler.writeFooter();
			

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/BSN/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("BSN Auto Debit Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);		
	}
	
	private ClaimFileBSNHandler getTextDownloadBSNHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileBSNHandler(excelDownloadVO, params);
	}
	
	/**
	 * My Clear - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileMyClear(EgovMap claimMap) throws Exception {

		ClaimFileMyClearHandler downloadHandler = null;
		String sFile;
		String todayDate;
		String inputDate;

		try {
			inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01"
					: (String) claimMap.get("ctrlBatchDt");
			todayDate = CommonUtils.getNowDate();
			sFile = "MyClear_Billing_" + todayDate + ".txt";

			downloadHandler = getTextDownloadMyClearHandler(sFile, claimFileColumns, null, filePath, "/MyClear/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFileMyClear(claimMap, downloadHandler);
			downloadHandler.writeFooter();
			

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/MyClear/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("My Clear Auto Debit Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
	}
	
	private ClaimFileMyClearHandler getTextDownloadMyClearHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileMyClearHandler(excelDownloadVO, params);
	}
	
	
	/**
	 * CRC CIMB - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileCrcCIMB(EgovMap claimMap) throws Exception {
		
		ClaimFileCrcCIMBHandler downloadHandler = null;
		String sFile;
		String todayDate;
		String inputDate;

		try {
			inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");
			todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");			
			sFile = "CRC_" + todayDate + "_" + String.valueOf(claimMap.get("pageNo"))   + ".csv";
			
			downloadHandler = getTextDownloadCrcCIMBHandler(sFile, claimFileColumns, null, filePath, "/CRC/", claimMap);			
			
			largeExcelService.downLoadClaimFileCrcCIMB(claimMap, downloadHandler);
			//downloadHandler.writeFooter();

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/CRC/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("CIMB Credit Card Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
		
	}
	
	private ClaimFileCrcCIMBHandler getTextDownloadCrcCIMBHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileCrcCIMBHandler(excelDownloadVO, params);
	}
	
	/**
	 * FPX - Create Claim File
	 * 
	 * @param claimMap
	 * @param claimDetailList
	 * @throws Exception
	 */
	public void createClaimFileFPX(EgovMap claimMap) throws Exception {
		ClaimFileFPXHandler downloadHandler = null;
		String sFile;
		String inputDate;

		try {
			inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");
			sFile = "CFT" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd") + "SE00000293" + "01.dat";

			downloadHandler = getTextDownloadFPXHandler(sFile, claimFileColumns, null, filePath, "/FPX/ClaimBank/", claimMap);			
			
			largeExcelService.downLoadClaimFileFPX(claimMap, downloadHandler);
			downloadHandler.writeFooter();
			

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}	
				
		// E-mail 전송하기
		File file = new File(filePath + "/FPX/ClaimBank/" + sFile);
		EmailVO email = new EmailVO();

		email.setTo(emailReceiver);
		email.setHtml(false);
		email.setSubject("FPX Auto Debit Claim File - Batch Date : " + inputDate);
		email.setText("Please find attached the claim file for your kind perusal.");
		email.addFile(file);

		adaptorService.sendEmail(email, false);
	}
	
	private ClaimFileFPXHandler getTextDownloadFPXHandler(String fileName, String[] columns, String[] titles, String path,
			String subPath, Map<String, Object> params) {
		FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
		excelDownloadVO.setFilePath(path);
		excelDownloadVO.setSubFilePath(subPath);
		return new ClaimFileFPXHandler(excelDownloadVO, params);
	}
}

