package com.coway.trust.web.payment.autodebit.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
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
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.biz.misc.voucher.impl.VoucherMapper;
import com.coway.trust.biz.payment.autodebit.service.ClaimService;
import com.coway.trust.biz.payment.autodebit.service.M2UploadVO;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.biz.payment.payment.service.vRescueBulkUploadVO;
import com.coway.trust.biz.payment.payment.service.ClaimResultScbUploadVO;
import com.coway.trust.biz.payment.payment.service.ClaimResultAmbUploadVO;
import com.coway.trust.biz.payment.payment.service.ClaimResultCimbUploadVO;
import com.coway.trust.biz.payment.payment.service.ClaimResultHsbcUploadVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.FileDownException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.claim.FormDef;
import com.coway.trust.web.common.excel.download.ExcelDownloadFormDef;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;
import com.coway.trust.web.common.claim.ClaimFileALBHandler;
import com.coway.trust.web.common.claim.ClaimFileBSNHandler;
import com.coway.trust.web.common.claim.ClaimFileCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcCIMBHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcDetExcelHandler;
import com.coway.trust.web.common.claim.ClaimFileCrcMBBHandler;
import com.coway.trust.web.common.claim.ClaimFileFPXHandler;
import com.coway.trust.web.common.claim.ClaimFileGeneralHandler;
import com.coway.trust.web.common.claim.ClaimFileHLBBHandler;
import com.coway.trust.web.common.claim.ClaimFileMBBHandler;
import com.coway.trust.web.common.claim.ClaimFileMyClearHandler;
import com.coway.trust.web.common.claim.ClaimFileNewALBHandler;
import com.coway.trust.web.common.claim.ClaimFilePBBHandler;
import com.coway.trust.web.common.claim.ClaimFileRHBHandler;
import com.coway.trust.web.common.claim.CreditCardFileCIMBHandler;
import com.coway.trust.web.common.claim.CreditCardFileMBBHandler;


import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class ClaimController {

  private static final Logger LOGGER = LoggerFactory.getLogger(ClaimController.class);

  @Value("${autodebit.file.upload.path}")
  private String filePath;

  @Value("${autodebit.email.receiver}")
  private String emailReceiver;

  @Value("${directdebit.cimb.keyname}")
  private String CIMB_DD_KEYNAME;

  @Autowired
  private AdaptorService adaptorService;

  @Resource(name = "voucherMapper")
	private VoucherMapper voucherMapper;

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
      "bankDtlDrBankTypeId", "bankDtlDrAccNo", "bankDtlDrName", "bankDtlAmt", "taskId", "crtUserId", "crtDt",
      "updUserId", "updDt", "bankDtlDrNric", "bankDtlRenStus", "svcCntrctId", "bankDtlBankId", "bankAppv",
      "bankDtlApprDt", "bic", "bankDtlFpxId", "fpxCode", "salesOrdNo", "bankDtlRptAmt", "bankDtlRenAmt",
      "bankDtlCrcExpr", "srvCntrctRefNo", "billNo", "cntrctNOrdNo", "bankAchCode", "code" };

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

  @RequestMapping(value = "/initCreditCardList.do")
  public String initCreditCardList(@RequestParam Map<String, Object> params, ModelMap model) {
    return "payment/autodebit/creditCardList";
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

      // CONVERT DECIMAL
      if (returnMap.get("ctrlBillAmt") != null) {
        returnMap.put("ctrlBillAmt", CommonUtils.getNumberFormat(returnMap.get("ctrlBillAmt").toString(), "#,##0.00"));
      }
      if (returnMap.get("ctrlBillPayAmt") != null) {
        returnMap.put("ctrlBillPayAmt",
            CommonUtils.getNumberFormat(returnMap.get("ctrlBillPayAmt").toString(), "#,##0.00"));
      }
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

    List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터
                                                                  // 가져오기
    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기
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

        if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc"))) || "2".equals(String.valueOf(claimMap.get("bankId")))
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
  public ResponseEntity<ReturnMessage> updateClaimResultItemBulk(MultipartHttpServletRequest request,
      SessionVO sessionVO) throws Exception {

    LOGGER.debug("ctrlId : {}  ", request.getParameter("ctrlId"));
    LOGGER.debug("ctrlIsCrc : {}  ", request.getParameter("ctrlIsCrc"));
    LOGGER.debug("bankId : {}  ", request.getParameter("bankId"));

    // Master 정보 세팅
    Map<String, Object> claimMap = new HashMap<String, Object>();
    claimMap.put("ctrlId", request.getParameter("ctrlId"));
    claimMap.put("ctrlIsCrc", request.getParameter("ctrlIsCrc"));
    claimMap.put("bankId", request.getParameter("bankId"));

    // CVS 파일 세팅
    Map<String, MultipartFile> fileMap = request.getFileMap();
    MultipartFile multipartFile = fileMap.get("csvFile");
    List<ClaimResultUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, false, ClaimResultUploadVO::create);

    // CVS 파일 객체 세팅
    Map<String, Object> cvsParam = new HashMap<String, Object>();
    cvsParam.put("voList", vos);
    cvsParam.put("userId", sessionVO.getUserId());

    // EgovMap resultMap = claimService.updateClaimResultItemBulk(claimMap,
    // cvsParam);
    EgovMap resultMap = claimService.updateClaimResultItemBulk2(claimMap, cvsParam);

    // 결과 만들기.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(resultMap);
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
  @RequestMapping(value = "/updateClaimResultItemBulk3.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateClaimResultItemBulk3(MultipartHttpServletRequest request,
      SessionVO sessionVO) throws Exception {

    LOGGER.debug("ctrlId : {}  ", request.getParameter("ctrlId"));
    LOGGER.debug("ctrlIsCrc : {}  ", request.getParameter("ctrlIsCrc"));
    LOGGER.debug("bankId : {}  ", request.getParameter("bankId"));

    // Master 정보 세팅
    Map<String, Object> claimMap = new HashMap<String, Object>();
    claimMap.put("ctrlId", request.getParameter("ctrlId"));
    claimMap.put("ctrlIsCrc", request.getParameter("ctrlIsCrc"));
    claimMap.put("bankId", request.getParameter("bankId"));

    // 기존 데이터 삭제
    claimService.deleteClaimResultItem(claimMap);

    // CVS 파일 세팅
    Map<String, MultipartFile> fileMap = request.getFileMap();
    MultipartFile multipartFile = fileMap.get("csvFile");
    List<ClaimResultUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, false, ClaimResultUploadVO::create);

    // CVS 파일 객체 세팅
    Map<String, Object> cvsParam = new HashMap<String, Object>();
    cvsParam.put("voList", vos);
    cvsParam.put("userId", sessionVO.getUserId());

    // 파일 내용 Insert
    claimService.updateClaimResultItemBulk3(claimMap, cvsParam);

    // Credit Card, ALB, CIMB가 아니면 Item 삭제한다.
    if (!"1".equals(String.valueOf(claimMap.get("ctrlIsCrc"))) && !"2".equals(String.valueOf(claimMap.get("bankId")))
        && !"3".equals(String.valueOf(claimMap.get("bankId")))) {
      claimService.removeItmId(claimMap);
    }

    // message 처리를 위한 값 세팅
    EgovMap resultMap = null;
    if ("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      resultMap = claimService.selectUploadResultBank(claimMap);
    } else if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))
        || "134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      resultMap = claimService.selectUploadResultCRC(claimMap);
    }

    // return resultMap;

    // 결과 만들기.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setData(resultMap);
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
  @RequestMapping(value = "/updateClaimResultItemBulk4.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateClaimResultItemBulk4(MultipartHttpServletRequest request,
      SessionVO sessionVO) throws Exception {

    LOGGER.debug("ctrlId : {}  ", request.getParameter("ctrlId"));
    LOGGER.debug("ctrlIsCrc : {}  ", request.getParameter("ctrlIsCrc"));
    LOGGER.debug("bankId : {}  ", request.getParameter("bankId"));
    LOGGER.debug("ddtChnl : {}  ", request.getParameter("ddtChnl"));
    LOGGER.debug("bankCode : {}  ", request.getParameter("bankCode"));

    // Master 정보 세팅
    Map<String, Object> claimMap = new HashMap<String, Object>();
    claimMap.put("ctrlId", request.getParameter("ctrlId"));
    claimMap.put("ctrlIsCrc", request.getParameter("ctrlIsCrc"));
    claimMap.put("bankId", request.getParameter("bankId"));
    claimMap.put("ddtChnl", request.getParameter("ddtChnl"));
    claimMap.put("bankCode", request.getParameter("bankCode"));

    // 기존 데이터 삭제
    claimService.deleteClaimResultItem(claimMap);

    // CVS 파일 세팅
    Map<String, MultipartFile> fileMap = request.getFileMap();
    MultipartFile multipartFile = fileMap.get("csvFile");
    if( claimMap.get("bankCode").equals("SCB") && claimMap.get("ctrlIsCrc").equals("1") ){
    	List<ClaimResultScbUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, false, ClaimResultScbUploadVO::create);

    	// CVS 파일 객체 세팅
        Map<String, Object> cvsParam = new HashMap<String, Object>();
        cvsParam.put("voList", vos);
        cvsParam.put("userId", sessionVO.getUserId());

        // 파일 내용 Insert
        // claimService.updateClaimResultItemBulk3(claimMap, cvsParam);
        // cvs 파일 저장 처리

        List<ClaimResultScbUploadVO> vos2 = (List<ClaimResultScbUploadVO>) cvsParam.get("voList");

        List<Map> list = vos2.stream().map(r -> {
          Map<String, Object> map = BeanConverter.toMap(r);

          map.put("refNo", r.getRefNo());
          map.put("refCode", r.getRefCode());
          map.put("id", claimMap.get("ctrlId"));
          map.put("itemId", r.getItemId());
          map.put("macCode", r.getMacCode());
          map.put("descResp", null);

          return map;
        }).collect(Collectors.toList());

        int size = 500;
        int page = list.size() / size;
        int start;
        int end;

        Map<String, Object> bulkMap = new HashMap<>();
        for (int i = 0; i <= page; i++) {
          start = i * size;
          end = size;

          if (i == page) {
            end = list.size();
          }
          if(list.stream().skip(start).limit(end).count() != 0){
              bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
              claimService.updateClaimResultItemBulk4(bulkMap);
          }
        }
    }
    else if( claimMap.get("bankCode").equals("CIMB") && claimMap.get("ctrlIsCrc").equals("1")){
    	List<ClaimResultCimbUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, false, ClaimResultCimbUploadVO::create);

    	// CVS 파일 객체 세팅
        Map<String, Object> cvsParam = new HashMap<String, Object>();
        cvsParam.put("voList", vos);
        cvsParam.put("userId", sessionVO.getUserId());

        // 파일 내용 Insert
        // claimService.updateClaimResultItemBulk3(claimMap, cvsParam);
        // cvs 파일 저장 처리

        List<ClaimResultCimbUploadVO> vos2 = (List<ClaimResultCimbUploadVO>) cvsParam.get("voList");

        List<Map> list = vos2.stream().map(r -> {
          Map<String, Object> map = BeanConverter.toMap(r);

          map.put("refNo", r.getRefNo());
          map.put("refCode", r.getRefCode());
          map.put("id", claimMap.get("ctrlId"));
          map.put("itemId", r.getItemId());
          map.put("macCode", null);
          map.put("descResp", null);

          return map;
        }).collect(Collectors.toList());

        int size = 500;
        int page = list.size() / size;
        int start;
        int end;

        Map<String, Object> bulkMap = new HashMap<>();
        for (int i = 0; i <= page; i++) {
          start = i * size;
          end = size;

          if (i == page) {
            end = list.size();
          }
          if(list.stream().skip(start).limit(end).count() != 0){
              bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
              claimService.updateClaimResultItemBulk4(bulkMap);
          }
        }
    }else if( claimMap.get("bankCode").equals("HSBC") && claimMap.get("ctrlIsCrc").equals("1")){
    	List<ClaimResultHsbcUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, false, ClaimResultHsbcUploadVO::create);

    	// CVS 파일 객체 세팅
        Map<String, Object> cvsParam = new HashMap<String, Object>();
        cvsParam.put("voList", vos);
        cvsParam.put("userId", sessionVO.getUserId());

        // 파일 내용 Insert
        // claimService.updateClaimResultItemBulk3(claimMap, cvsParam);
        // cvs 파일 저장 처리

        List<ClaimResultHsbcUploadVO> vos2 = (List<ClaimResultHsbcUploadVO>) cvsParam.get("voList");

        List<Map> list = vos2.stream().map(r -> {
          Map<String, Object> map = BeanConverter.toMap(r);

          map.put("refNo", r.getRefNo());
          map.put("refCode", r.getRefCode());
          map.put("id", claimMap.get("ctrlId"));
          map.put("itemId", r.getItemId());
          map.put("macCode", null);

          // since got 2 type of token
          String descResp = r.getDescResp();

          if (descResp == null || descResp.isEmpty()) {
        	  map.put("descResp", null);
          } else {
        	  map.put("descResp", descResp);
          }

          return map;
        }).collect(Collectors.toList());

        int size = 500;
        int page = list.size() / size;
        int start;
        int end;

        Map<String, Object> bulkMap = new HashMap<>();
        for (int i = 0; i <= page; i++) {
          start = i * size;
          end = size;

          if (i == page) {
            end = list.size();
          }
          if(list.stream().skip(start).limit(end).count() != 0){
              bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
              claimService.updateClaimResultItemBulk4(bulkMap);
          }
        }
    }else if( claimMap.get("bankCode").equals("AMB") && claimMap.get("ctrlIsCrc").equals("1")){
      List<ClaimResultAmbUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, false, ClaimResultAmbUploadVO::create);

      // CVS 파일 객체 세팅
        Map<String, Object> cvsParam = new HashMap<String, Object>();
        cvsParam.put("voList", vos);
        cvsParam.put("userId", sessionVO.getUserId());

        // 파일 내용 Insert
        // claimService.updateClaimResultItemBulk3(claimMap, cvsParam);
        // cvs 파일 저장 처리

        List<ClaimResultAmbUploadVO> vos2 = (List<ClaimResultAmbUploadVO>) cvsParam.get("voList");

        List<Map> list = vos2.stream().map(r -> {
          Map<String, Object> map = BeanConverter.toMap(r);

          map.put("refCode", CommonUtils.nvl(r.getApprCode()).equals("A") ? "00" : r.getRefCode());
          map.put("apprCode", !CommonUtils.nvl(r.getApprCode()).equals("A") ? "0" : r.getRefCode());
          map.put("id", claimMap.get("ctrlId"));
          map.put("itemId", r.getItemId());
          map.put("macCode", null);
          map.put("descResp", null);

          return map;
        }).collect(Collectors.toList());

        int size = 500;
        int page = list.size() / size;
        int start;
        int end;

        Map<String, Object> bulkMap = new HashMap<>();
        for (int i = 0; i <= page; i++) {
          start = i * size;
          end = size;

          if (i == page) {
            end = list.size();
          }
          if(list.stream().skip(start).limit(end).count() != 0){
              bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
              claimService.updateClaimResultItemBulk4(bulkMap);
          }
        }
    }
    else{
        List<ClaimResultUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, false, ClaimResultUploadVO::create);

        // CVS 파일 객체 세팅
        Map<String, Object> cvsParam = new HashMap<String, Object>();
        cvsParam.put("voList", vos);
        cvsParam.put("userId", sessionVO.getUserId());

        // 파일 내용 Insert
        // claimService.updateClaimResultItemBulk3(claimMap, cvsParam);
        // cvs 파일 저장 처리

        List<ClaimResultUploadVO> vos2 = (List<ClaimResultUploadVO>) cvsParam.get("voList");

        List<Map> list = vos2.stream().map(r -> {
          Map<String, Object> map = BeanConverter.toMap(r);

          map.put("refNo", r.getRefNo());
          map.put("refCode", r.getRefCode());
          map.put("id", claimMap.get("ctrlId"));
          map.put("itemId", r.getItemId());
          map.put("macCode", null);
          map.put("descResp", null);

          return map;
        }).collect(Collectors.toList());

        int size = 500;
        int page = list.size() / size;
        int start;
        int end;

        Map<String, Object> bulkMap = new HashMap<>();
        for (int i = 0; i <= page; i++) {
          start = i * size;
          end = size;

          if (i == page) {
            end = list.size();
          }
          if(list.stream().skip(start).limit(end).count() != 0){
              bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
              claimService.updateClaimResultItemBulk4(bulkMap);
          }
        }
    }

    // 업로드된 값을 재정리 한다. REF_CODE / REF_NO LPAD 처리
    claimService.updateClaimResultItemArrange(claimMap);

    // Credit Card, ALB, CIMB가 아니면 Item 삭제한다.
    if (!"1".equals(String.valueOf(claimMap.get("ctrlIsCrc"))) && !"2".equals(String.valueOf(claimMap.get("bankId")))
        && !"3".equals(String.valueOf(claimMap.get("bankId")))) {
      claimService.removeItmId(claimMap);
    }

    // message 처리를 위한 값 세팅
    EgovMap resultMap = null;
    if ("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      resultMap = claimService.selectUploadResultBank(claimMap);
    } else if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))
        || "134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      resultMap = claimService.selectUploadResultCRC(claimMap);
    }

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

    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기

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

    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기

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
  public ResponseEntity<ReturnMessage> generateNewClaim(@RequestBody Map<String, ArrayList<Object>> params, Model model,
      SessionVO sessionVO) {

    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기
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
    LOGGER.debug("new_ddtChnl : {}", claim.get("new_ddtChnl"));
    LOGGER.debug("new_issueBank : {}", claim.get("new_issueBank"));
    LOGGER.debug("new_debitDate : {}", claim.get("new_debitDate"));

    // HasActiveBatch : 동일한 bankId, Claim Type 에 해당하는 active 건이 있는지 확인한다.
    searchMap = new HashMap<String, Object>();
    searchMap.put("ddtChnl", claim.get("new_ddtChnl"));
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
      String inputDate = CommonUtils.changeFormat(String.valueOf(claim.get("new_debitDate")), "dd/MM/yyyy", "yyyyMMdd");
      String claimDay = CommonUtils.nvl(String.valueOf(claim.get("new_claimDay")));
      String ddtChnl = CommonUtils.nvl(String.valueOf(claim.get("new_ddtChnl")));
      String bankId = CommonUtils.nvl(String.valueOf(claim.get("new_issueBank")));
      String cardType = CommonUtils.nvl(String.valueOf(claim.get("new_cardType")));

      claim.put("new_claimType", isCRC);
      claim.put("new_debitDate", inputDate);
      claim.put("new_claimDay", claimDay);
      claim.put("new_ddtChnl", ddtChnl);
      claim.put("new_issueBank", bankId);
      claim.put("new_cardType", cardType);
      claim.put("userId", sessionVO.getUserId());

      claimService.createClaim(claim); // 프로시저 함수 호출
      List<EgovMap> resultMapList = (List<EgovMap>) claim.get("p1"); // 결과 뿌려보기
                                                                     // : 프로시저에서
                                                                     // p1이란
                                                                     // key값으로
                                                                     // 객체를
                                                                     // 반환한다.

      if (resultMapList.size() > 0) {
        // 프로시저 결과 Map
        returnMap = (Map<String, Object>) resultMapList.get(0);

        // Calim Master 및 Detail 조회
        // EgovMap claimMasterMap = claimService.selectClaimById(returnMap);
        // List<EgovMap> claimDetailList =
        // claimService.selectClaimDetailById(returnMap);

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
   * Claim Result Update LIVE 처리
   *
   * @param params
   * @param model
   * @return
   * @RequestParam Map<String, Object> params
   */
  @RequestMapping(value = "/updateCreditCardResultLive.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateCreditCardResultLive(@RequestBody Map<String, ArrayList<Object>> params,
      Model model, SessionVO sessionVO) {

    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기

    // 폼객체 처리.
    Map<String, Object> claimMap = (Map<String, Object>) formList.get(0);
    claimMap.put("userId", sessionVO.getUserId());

    // 데이터 수정
    claimService.updateCreditCardResultLive(claimMap);

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
  @RequestMapping(value = "/generateNewCreditCardClaim.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> generateNewCreditCardClaim(@RequestBody Map<String, ArrayList<Object>> params,
      Model model, SessionVO sessionVO) {

    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기

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

    // HasActiveBatch : 동일한 bankId, Claim Type 에 해당하는 active 건이 있는지 확인한다.
    searchMap = new HashMap<String, Object>();
    searchMap.put("issueBank", claim.get("new_merchantBank"));
    searchMap.put("claimType", claim.get("new_claimType"));
    searchMap.put("status", "1");
    searchMap.put("IS_GRP", "1");

    //List<EgovMap> isActiveBatchList = claimService.selectClaimList(searchMap);

    // Active인 배치가 있는 경우
/*    if (isActiveBatchList.size() > 0) {
      returnCode = "IS_BATCH";
      returnMap = (Map<String, Object>) isActiveBatchList.get(0);
    } else {*/

      String isCRC = "131".equals((String.valueOf(claim.get("new_claimType")))) ? "1"
          : "132".equals((String.valueOf(claim.get("new_claimType")))) ? "0" : "134";
      String inputDate = (claim.get("new_debitDate") == "" || claim.get("new_debitDate") == null)
          ? CommonUtils.changeFormat(CommonUtils.getNowDate(), "dd/MM/yyyy", "yyyyMMdd")
          : CommonUtils.changeFormat(String.valueOf(claim.get("new_debitDate")), "dd/MM/yyyy", "yyyyMMdd");
      String issueBankId = CommonUtils.nvl(String.valueOf(claim.get("hiddenIssueBank")));
      String bankId = CommonUtils.nvl(String.valueOf(claim.get("new_merchantBank")));
      String cardType = CommonUtils.nvl(String.valueOf(claim.get("new_cardType")));
      String mayBank = CommonUtils.nvl(String.valueOf(claim.get("_mayBank")));
      String installMonth = CommonUtils.nvl(String.valueOf(claim.get("hiddenMonth")));
      String custType = CommonUtils.nvl(String.valueOf(claim.get("custType")));
      String monthType = CommonUtils.nvl(String.valueOf(claim.get("monthType")));

      claim.put("new_claimType", isCRC);
      claim.put("new_debitDate", inputDate);
      claim.put("new_issueBankId", issueBankId);
      claim.put("new_merchantBank", bankId);
      claim.put("new_cardType", cardType);
      claim.put("new_issueBankId", issueBankId);
      claim.put("mayBank", mayBank);
      claim.put("installMonth", installMonth);
      claim.put("userId", sessionVO.getUserId());
      claim.put("custType", custType);
      claim.put("monthType", monthType);

      claimService.createClaimCreditCard(claim); // 프로시저 함수 호출
      List<EgovMap> resultMapList = (List<EgovMap>) claim.get("p1"); // 결과 뿌려보기
                                                                     // : 프로시저에서
                                                                     // p1이란
                                                                     // key값으로
                                                                     // 객체를
                                                                     // 반환한다.

      if (resultMapList.size() > 0) {
        returnMap = (Map<String, Object>) resultMapList.get(0);
        try {
          returnCode = "FILE_OK";
        } catch (Exception e) {
          returnCode = "FILE_FAIL";
        }
      } else {
        returnCode = "FAIL";
      }
    //}

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
   *
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
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/selectScheduleClaimBatchPop.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectScheduleClaimBatchPop(@RequestParam Map<String, Object> params,
      ModelMap model, HttpServletRequest request) {

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
   *
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
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/selectScheduleClaimSettingPop.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectScheduleClaimSettingPop(@RequestParam Map<String, Object> params,
      ModelMap model, HttpServletRequest request) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    List<EgovMap> resultList = claimService.selectScheduleClaimSettingPop(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/isScheduleClaimSettingPop.do", method = RequestMethod.GET)
  public ResponseEntity<Integer> isScheduleClaimSettingPop(@RequestParam Map<String, Object> params, ModelMap model,
      HttpServletRequest request) {

    LOGGER.debug("params : {} ", params);
    // 조회.
    int resultCnt = claimService.isScheduleClaimSettingPop(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultCnt);
  }

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 저장
   *
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
   *
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
  public ResponseEntity<ReturnMessage> createClaimFile(@RequestBody Map<String, ArrayList<Object>> params, Model model)
      throws Exception {

    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기
    // Calim Master 데이터 조회
    Map<String, Object> map = (Map<String, Object>) formList.get(0);
    EgovMap claimMap = claimService.selectClaimById(map);
    String isZip = "";

    if(!"3182".equals(String.valueOf(claimMap.get("ctrlDdtChl")))){
      List<EgovMap> fileInfo = claimService.selectMstConf(claimMap);
      if(fileInfo.size() > 0){
        Map<String, Object> fileInfoConf = new HashMap<String, Object>();
        fileInfoConf = (Map<String, Object>) fileInfo.get(0);

        claimMap.put("batchName", fileInfoConf.get("ctrlFileNm"));
        claimMap.put("ext", fileInfoConf.get("ctrlFileExt"));
        claimMap.put("subPath", fileInfoConf.get("ctrlSubPath"));
        claimMap.put("emailSubject", fileInfoConf.get("ctrlEmailSubj"));
        claimMap.put("emailBody", fileInfoConf.get("ctrlEmailText"));

        isZip  = fileInfoConf.get("ctrlZip").toString();
      }
    }

    // 파일 생성하기
    if ("0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      if ("3182".equals(String.valueOf(claimMap.get("ctrlDdtChl")))) { // e-Mandate
        this.createClaimFileGenerator(claimMap);
      } else { // General
        // ALB
        if ("2".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // this.createClaimFileALB(claimMap);
          // claimService.deleteClaimFileDownloadInfo(claimMap);
          this.createClaimFileNewALB(claimMap);
        }

        // CIMB
        if ("3".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // claimService.deleteClaimFileDownloadInfo(claimMap);
          this.createClaimFileCIMB(claimMap);
        }

        // HLBB
        /*if ("5".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // claimService.deleteClaimFileDownloadInfo(claimMap);
          this.createClaimFileHLBB(claimMap);
          this.createClaimFileHLBB2(claimMap);
        }*/

        // MBB
        if ("21".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // claimService.deleteClaimFileDownloadInfo(claimMap);
          this.createClaimFileMBB(claimMap);
        }

        // PBB
        if ("6".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // claimService.deleteClaimFileDownloadInfo(claimMap);
          this.createClaimFilePBB(claimMap);
        }

        // RHB
        if ("7".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // claimService.deleteClaimFileDownloadInfo(claimMap);
          this.createClaimFileRHB(claimMap);
        }

        // BSN
        if ("9".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // claimService.deleteClaimFileDownloadInfo(claimMap);
          this.createClaimFileBSN(claimMap);
        }

        // My Clear
       /* if ("46".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // claimService.deleteClaimFileDownloadInfo(claimMap);
          this.createClaimFileMyClear(claimMap);
        }*/
      }
    } else if ("1".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {

      String isCrc = map.get("isCrc") != null ? (String) map.get("isCrc") : "";

      if (isCrc.equals("crc")) {
        if ("3".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // 10000건 단위로 추출하기 위해 전체 건수 조회
          int totRowCount = claimService.selectCCClaimDetailByIdCnt(map);
          int pageCnt = (int) Math.round(Math.ceil(totRowCount / 10000.0));

          if (pageCnt > 0) {
            for (int i = 1; i <= pageCnt; i++) {
              claimMap.put("pageNo", i);
              claimMap.put("rowCount", 10000);
              this.createCreditCardFileCIMB(claimMap);
            }
          }
        } else if ("19".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          int totRowCount = claimService.selectCCClaimDetailByIdCnt(map);
          int totBatToday = claimService.selectClaimDetailBatchGen(map);
          int pageCnt = (int) Math.round(Math.ceil(totRowCount / 999.0));

          if (pageCnt > 0) {
            for (int i = 1; i <= pageCnt; i++) {
              claimMap.put("pageNo", i);
              claimMap.put("rowCount", 999);
              claimMap.put("batchNo", totBatToday);
              claimMap.put("pageCnt", pageCnt);
              claimMap.put("type", 1);
              this.createCreditCardFileMBB(claimMap);

              claimMap.put("type", 2);
              this.createCreditCardFileMBB(claimMap);
            }
          }
        } else if("17".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
            // createCreditCardFileHSBC
            int totRowCount = claimService.selectCCClaimDetailByIdCnt(map);
            int totBatToday = claimService.selectClaimDetailBatchGen(map);
            int pageCnt = (int) Math.round(Math.ceil(totRowCount / 99999.0));

            if(pageCnt > 0) {
                for(int i = 1; i <= pageCnt; i++) {
                    claimMap.put("pageNo", i);
                    claimMap.put("rowCount", 99999);
                    claimMap.put("batchNo", totBatToday);
                    claimMap.put("pageCnt", pageCnt);

                    this.createCreditCardFileHSBC(claimMap);
                }
            }
        } else if("23".equals(String.valueOf(claimMap.get("ctrlBankId")))) { // Ambank
          // createCreditCardFileAMB
          int totRowCount = claimService.selectCCClaimDetailByIdCnt(map);
          int totBatToday = claimService.selectClaimDetailBatchGen(map);
          int pageCnt = (int) Math.round(Math.ceil(totRowCount / 60000.0));

          if(pageCnt > 0) {
              for(int i = 1; i <= pageCnt; i++) {
                  claimMap.put("pageNo", i);
                  claimMap.put("rowCount", 60000);
                  claimMap.put("batchNo", claimMap.get("ctrlId"));
                  claimMap.put("pageCnt", pageCnt);

                  this.createCreditCardFileAMB(claimMap);
              }
          }
      }
      }
      /* else {
        if ("3".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          // 10000건 단위로 추출하기 위해 전체 건수 조회
          int totRowCount = claimService.selectClaimDetailByIdCnt(map);
          int pageCnt = (int) Math.round(Math.ceil(totRowCount / 10000.0));

          if (pageCnt > 0) {
            for (int i = 1; i <= pageCnt; i++) {
              claimMap.put("pageNo", i);
              claimMap.put("rowCount", 10000);
              this.createClaimFileCrcCIMB(claimMap, i);
            }

            batchName = "CRC";
            fileDirectory = filePath + "/CRC/CIMB/";
            batchDate   = claimMap.get("ctrlBatchDt").toString();
            emailSubject = "CIMB CRC";
            zipFilesEmail(claimMap,batchName, fileDirectory, batchDate,emailSubject);
          }
        } else if ("19".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
          int totRowCount = claimService.selectClaimDetailByIdCnt(map);
          int totBatToday = claimService.selectClaimDetailBatchGen(map);
          int pageCnt = (int) Math.round(Math.ceil(totRowCount / 999.0));

          if (pageCnt > 0) {
            for (int i = 1; i <= pageCnt; i++) {
              claimMap.put("pageNo", i);
              claimMap.put("rowCount", 999);
              claimMap.put("batchNo", totBatToday);
              claimMap.put("pageCnt", pageCnt);
              claimMap.put("type", 1);
              this.createClaimFileCrcMBB(claimMap);

              claimMap.put("type", 2);
              this.createClaimFileCrcMBB(claimMap);
            }

            batchName = "CZ";
            fileDirectory = filePath + "/CRC/MBB/";
            batchDate   = claimMap.get("ctrlBatchDt").toString();
            emailSubject = "SCB CRC Deduction File";
            zipFilesEmail(claimMap,batchName, fileDirectory, batchDate,emailSubject);
          }
        }
      }*/

    } else if ("134".equals(String.valueOf(claimMap.get("ctrlIsCrc")))) {
      // claimService.deleteClaimFileDownloadInfo(claimMap);
      this.createClaimFileFPX(claimMap);
    }

    //Zip Files to email and download
    if(isZip.equals("Y")){
      zipFilesEmail(claimMap);

      if(requireFileEncrypt(claimMap)) {
    	  generateEncryptFile(claimMap);
          //zipFilesEncrypt(claimMap);
      }

    }

//    Date today = new Date();
//	SimpleDateFormat format1 = new SimpleDateFormat("dd");
//	String day = format1.format(today);
//    if(day.equals("24")){//20240829
//
//    	// insert batch email table
//    	int mailIDNextVal = voucherMapper.getBatchEmailNextVal();
//
//    	String zipFile = filePath + claimMap.get("subPath").toString() + claimMap.get("batchName").toString() + '_' +claimMap.get("ctrlBatchDt").toString() + ".zip";
//
//        Map<String,Object> emailDet = new HashMap<String, Object>();
//        emailDet.put("mailId", mailIDNextVal);
//        emailDet.put("emailType",AppConstants.EMAIL_TYPE_NORMAL);
//        emailDet.put("attachment", zipFile);
//        emailDet.put("categoryId", 5);
//        emailDet.put("emailParams", claimMap.get("emailBody").toString());
//        emailDet.put("email", emailReceiver);
//        //emailDet.put("email", "huiding.teoh@coway.com.my");
//        emailDet.put("emailSentStus", 1);
//        emailDet.put("name", "");
//        emailDet.put("userId", 349);
//        emailDet.put("emailSubject", claimMap.get("emailSubject").toString().replace("{0}", claimMap.get("ctrlBatchDt").toString()));
//
//        voucherMapper.insertBatchEmailSender(emailDet);
//
//    }

    //create order basic claim file
    createClaimFileExcel(claimMap);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(claimMap.get("file").toString());

    if (claimMap.get("encFile") != null && !claimMap.get("encFile").toString().equals("")) {
        message.setData(claimMap.get("encFile").toString());
    }

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
    String fileName = claimMap.get("batchName").toString();
    String subPath = claimMap.get("subPath").toString();
    String ext = claimMap.get("ext").toString();
    String emailSubject = claimMap.get("emailSubject").toString();
    String emailBody = claimMap.get("emailBody").toString();

    try {
      todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
      sFile = fileName + todayDate + "." + ext;

      downloadHandler = getTextDownloadNewALBHandler(sFile, claimFileColumns, null, filePath, subPath, claimMap);

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

    // //파일다운로드 정보 INSERT
    // claimMap.put("fileNo", 1);
    // claimMap.put("filePath", fileDownloadPath+"/ALB/ClaimBank/");
    // claimMap.put("fileName", sFile);
    //
    // claimService.insertClaimFileDownloadInfo(claimMap);

    // E-mail 전송하기
    File file = new File(filePath + subPath + sFile);
    claimMap.put("file", subPath + sFile);

    EmailVO email = new EmailVO();

    email.setTo(emailReceiver);
    email.setHtml(false);
    email.setSubject(emailSubject.replace("{0}", CommonUtils.nvl(claimMap.get("ctrlBatchDt"))));
    email.setText(emailBody);
    email.addFile(file);

    adaptorService.sendEmail(email, false);

  }

  private ClaimFileNewALBHandler getTextDownloadNewALBHandler(String fileName, String[] columns, String[] titles,
      String path, String subPath, Map<String, Object> params) {
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

    String fileName = claimMap.get("batchName").toString();
    String subPath = claimMap.get("subPath").toString();

    try {
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");

      sFile = fileName + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy") + ".txt";

      downloadHandler = getTextDownloadCIMBHandler(sFile, claimFileColumns, null, filePath, subPath+inputDate+"/", claimMap);

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

  }

  private ClaimFileCIMBHandler getTextDownloadCIMBHandler(String fileName, String[] columns, String[] titles,
      String path, String subPath, Map<String, Object> params) {
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
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01"
          : (String) claimMap.get("ctrlBatchDt");

      sFile = "EPY1000991_" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyyyy") + ".csv";

      downloadHandler = getTextDownloadHLBBHandler(sFile, claimFileColumns, null, filePath, "/HLBB/ClaimBank/",
          claimMap);

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

    // //파일다운로드 정보 INSERT
    // claimMap.put("fileNo", 1);
    // claimMap.put("filePath", fileDownloadPath+"/HLBB/ClaimBank/");
    // claimMap.put("fileName", sFile);
    //
    // claimService.insertClaimFileDownloadInfo(claimMap);

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

  public void createClaimFileHLBB2(EgovMap claimMap) throws Exception {

    ClaimFileHLBBHandler downloadHandler = null;
    String sFile;
    String inputDate;

    try {
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01"
          : (String) claimMap.get("ctrlBatchDt");

      sFile = "HLBB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd") + "B01.csv";

      downloadHandler = getTextDownloadHLBBHandler(sFile, claimFileColumns, null, filePath, "/HLBB/ClaimBank/",
          claimMap);

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

  private ClaimFileHLBBHandler getTextDownloadHLBBHandler(String fileName, String[] columns, String[] titles,
      String path, String subPath, Map<String, Object> params) {
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
    String fileName = claimMap.get("batchName").toString();
    String subPath = claimMap.get("subPath").toString();
    String ext = claimMap.get("ext").toString();
    String emailSubject = claimMap.get("emailSubject").toString();
    String emailBody = claimMap.get("emailBody").toString();

    try {
      ctrlBatchDt = (String) claimMap.get("ctrlBatchDt");
      inputDate = CommonUtils.nvl(ctrlBatchDt).equals("") ? "1900-01-01" : ctrlBatchDt;
      sFile = fileName + "." + ext;

      downloadHandler = getTextDownloadMBBHandler(sFile, claimFileColumns, null, filePath, subPath + inputDate + "/", claimMap);

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

    // //파일다운로드 정보 INSERT
    // claimMap.put("fileNo", 1);
    // claimMap.put("filePath", fileDownloadPath+"/MBB/ClaimBank/");
    // claimMap.put("fileName", sFile);
    //
    // claimService.insertClaimFileDownloadInfo(claimMap);

    // E-mail 전송하기
/*    File file = new File(filePath + subPath + sFile);
    claimMap.put("file", subPath + sFile);

    EmailVO email = new EmailVO();

    email.setTo(emailReceiver);
    email.setHtml(false);
    email.setSubject(emailSubject.replace("{0}", inputDate));
    email.setText(emailBody);
    email.addFile(file);

    adaptorService.sendEmail(email, false);*/
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
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01"
          : (String) claimMap.get("ctrlBatchDt");
      sFile = "WCBPBB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy") + "01.DIF";

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

    // //파일다운로드 정보 INSERT
    // claimMap.put("fileNo", 1);
    // claimMap.put("filePath", fileDownloadPath+"/PBB/ClaimBank/");
    // claimMap.put("fileName", sFile);
    //
    // claimService.insertClaimFileDownloadInfo(claimMap);

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
    String sFile2nd = "WCBPBB" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy") + "01.DTR";

    // 파일 디렉토리
    File file2nd = new File(filePath + "/PBB/ClaimBank/" + sFile2nd);

    // 디렉토리 생성
    if (!file2nd.getParentFile().exists()) {
      file2nd.getParentFile().mkdirs();
    }

    FileWriter fileWriter2nd = new FileWriter(file2nd);
    BufferedWriter out2nd = new BufferedWriter(fileWriter2nd);

    String count = StringUtils.leftPad(String.valueOf(Integer.parseInt(String.valueOf(claimMap.get("ctrlTotItm"))) + 2),
        6, " ");
    String iTotalAmtStr = StringUtils
        .leftPad(
            CommonUtils.getNumberFormat(
                String.valueOf(((java.math.BigDecimal) claimMap.get("ctrlBillAmt")).doubleValue()), "###,###,###.00"),
            13, " ");

    StringBuffer sb = new StringBuffer();

    sb.append("                                                         PAGE: 1").append("\n");
    sb.append("                                                         REPORT DATE: "
        + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "dd/MM/yyyy")).append("\n");
    sb.append("").append("\n");
    // sb.append(" WOONGJIN COWAY (M) SDN BHD").append("\n");
    sb.append("                           COWAYM COWAY (M) SDN BHD").append("\n");
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

    // 파일다운로드 정보 INSERT
    // claimMap.put("fileNo", 2);
    // claimMap.put("filePath", fileDownloadPath+"/PBB/ClaimBank/");
    // claimMap.put("fileName", sFile2nd);
    //
    // claimService.insertClaimFileDownloadInfo(claimMap);

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
    String fileName = claimMap.get("batchName").toString();
    String subPath = claimMap.get("subPath").toString();
    String ext = claimMap.get("ext").toString();
    String emailSubject = claimMap.get("emailSubject").toString();
    String emailBody = claimMap.get("emailBody").toString();

    try {
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01"
          : (String) claimMap.get("ctrlBatchDt");
      todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
      sFile = fileName + todayDate + ext;

      downloadHandler = getTextDownloadRHBHandler(sFile, claimFileColumns, null, filePath, subPath, claimMap);

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

    // //파일다운로드 정보 INSERT
    // claimMap.put("fileNo", 1);
    // claimMap.put("filePath", fileDownloadPath+"/RHB/ClaimBank/");
    // claimMap.put("fileName", sFile);
    //
    // claimService.insertClaimFileDownloadInfo(claimMap);

    // E-mail 전송하기
    File file = new File(filePath + subPath + sFile);
    claimMap.put("file", subPath + sFile);

    EmailVO email = new EmailVO();

    email.setTo(emailReceiver);
    email.setHtml(false);
    email.setSubject(emailSubject.replace("{0}", inputDate));
    email.setText(emailBody);
    email.addFile(file);

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
    String fileName = claimMap.get("batchName").toString();
    String subPath = claimMap.get("subPath").toString();
    String ext = claimMap.get("ext").toString();
    String emailSubject = claimMap.get("emailSubject").toString();
    String emailBody = claimMap.get("emailBody").toString();

    try {

      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01"
          : (String) claimMap.get("ctrlBatchDt");
      todayDate = CommonUtils.getNowDate();
      sFile = fileName + todayDate + ext;

      downloadHandler = getTextDownloadBSNHandler(sFile, claimFileColumns, null, filePath, subPath, claimMap);

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

    // //파일다운로드 정보 INSERT
    // claimMap.put("fileNo", 1);
    // claimMap.put("filePath", fileDownloadPath+"/BSN/ClaimBank/");
    // claimMap.put("fileName", sFile);
    //
    // claimService.insertClaimFileDownloadInfo(claimMap);

    // E-mail 전송하기
    File file = new File(filePath + subPath + sFile);
    claimMap.put("file", subPath + sFile);

    EmailVO email = new EmailVO();

    email.setTo(emailReceiver);
    email.setHtml(false);
    email.setSubject(emailSubject.replace("{0}", inputDate));
    email.setText(emailBody);
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

      downloadHandler = getTextDownloadMyClearHandler(sFile, claimFileColumns, null, filePath, "/MyClear/ClaimBank/",
          claimMap);

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

    // //파일다운로드 정보 INSERT
    // claimMap.put("fileNo", 1);
    // claimMap.put("filePath", fileDownloadPath+"/MyClear/ClaimBank/");
    // claimMap.put("fileName", sFile);
    //
    // claimService.insertClaimFileDownloadInfo(claimMap);

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

  private ClaimFileMyClearHandler getTextDownloadMyClearHandler(String fileName, String[] columns, String[] titles,
      String path, String subPath, Map<String, Object> params) {
    FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
    excelDownloadVO.setFilePath(path);
    excelDownloadVO.setSubFilePath(subPath);
    return new ClaimFileMyClearHandler(excelDownloadVO, params);
  }

  /**
   * General - Create Claim File
   *
   * @param claimMap
   * @param claimDetailList
   * @throws Exception
   */
  public void createClaimFileGenerator(EgovMap claimMap) throws Exception {
    ClaimFileGeneralHandler downloadHandler = null;
    String sFile = "";
    String bnkCde = "";
    String bchId = "";
    String subPath = "";
    String todayDate = "";
    String inputDate = "";

    /*
     * {0} - TODAY DATE
     * {1} - BANK SHORT CODE
     * {2} - BATCH ID
     */
    Map<String, Object> map = new HashMap<String, Object>();
    map.put("ctrlIsCrc", claimMap.get("ctrlIsCrc"));
    //map.put("ctrlBankId", claimMap.get("ctrlBankId"));
    map.put("ctrlBankId", "0");
    List<EgovMap> fileInfo = claimService.selectMstConf(map);

    if (fileInfo.size() == 0) {
      // GET GENERATE SETTING
      //map.put("ctrlBankId", "0");
      fileInfo = claimService.selectMstConf(map);
    }

    try {
      if (fileInfo.size() > 0) {
        for (int a = 0; a < fileInfo.size(); a++) {
          Map<String, Object> fileInfoConf = new HashMap<String, Object>();
          fileInfoConf = (Map<String, Object>) fileInfo.get(a);
          claimMap.put("ctrlConfId", fileInfoConf.get("id"));

          inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");
          bnkCde = CommonUtils.nvl(claimMap.get("ctrlBankId"));
          if (!bnkCde.equals("")) {
            bnkCde = claimService.selectBnkCde(bnkCde);
          }

          bchId = CommonUtils.nvl(claimMap.get("ctrlId")).equals("") ? inputDate
              : new BigDecimal(claimMap.get("ctrlId").toString()).toPlainString();

          // FORM FILE NAME
          if (CommonUtils.nvl(fileInfoConf.get("ctrlDtFmt")).equals("")) {
            todayDate = CommonUtils.getNowDate();
          } else {
            todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd",
                fileInfoConf.get("ctrlDtFmt").toString());
          }

          sFile = fileInfoConf.get("ctrlFileNm").toString().replace("{0}", todayDate).replace("{1}", bnkCde).replace("{2}", bchId) + "."
              + (fileInfoConf.get("ctrlFileExt").toString().replace(".", "").toLowerCase());

          subPath = CommonUtils.nvl(fileInfoConf.get("ctrlSubPath")).toString().replace("{0}", todayDate).replace("{1}",
              bnkCde);

          downloadHandler = getTextDownloadGeneralHandler(sFile, claimFileColumns, null, filePath, subPath, claimMap);
          largeExcelService.downLoadClaimFileGeneral(claimMap, downloadHandler);
          downloadHandler.writeFooter();

          LOGGER.debug(">>>>>>>>>>>>>>>>>> claimMap test: " + claimMap);
        }
      }
    } catch (Exception ex) {
      LOGGER.debug(ex.getMessage());
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

    // SEND EMAIL
    if (fileInfo.size() > 0) {
      for (int a = 0; a < fileInfo.size(); a++) {
        Map<String, Object> fileInfoConf = new HashMap<String, Object>();
        fileInfoConf = (Map<String, Object>) fileInfo.get(a);

        if (CommonUtils.nvl(fileInfoConf.get("ctrlEmail")).toString().toUpperCase().equals("Y")) { // CTRL_EMAIL
          File file = new File(filePath + fileInfoConf.get("ctrlSubPath").toString() + sFile);

          String emailSubj = fileInfoConf.get("ctrlEmailSubj").toString().replace("{0}", inputDate).replace("{1}", bnkCde).replace("{2}", bchId);
          String emailTxt = fileInfoConf.get("ctrlEmailText").toString();

          EmailVO email = new EmailVO();
          email.setTo(emailReceiver);
          email.setHtml(false);
          email.setSubject(emailSubj);
          email.setText(emailTxt);
          email.addFile(file);

          adaptorService.sendEmail(email, false);

        }

        claimMap.put("file", subPath + sFile);

      }
    }

  }

private ClaimFileGeneralHandler getTextDownloadGeneralHandler(String fileName, String[] columns, String[] titles,
      String path, String subPath, Map<String, Object> params) {
    FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
    excelDownloadVO.setFilePath(path);
    excelDownloadVO.setSubFilePath(subPath);

    Map<String, Object> confPrm = new HashMap<String, Object>();
    confPrm.put("id", params.get("ctrlConfId").toString());
    confPrm.put("part", "H");

    List<EgovMap> headerInfo = claimService.selectSubConf(confPrm); // HEADER

    confPrm.put("part", "D");
    List<EgovMap> datailInfo = claimService.selectSubConf(confPrm); // DETAIL

    confPrm.put("part", "T");
    List<EgovMap> trailerInfo = claimService.selectSubConf(confPrm); // FOOTER

    return new ClaimFileGeneralHandler(excelDownloadVO, headerInfo, datailInfo, trailerInfo, params);
  }

  /**
   * CRC CIMB - Create Claim File
   *
   * @param claimMap
   * @param claimDetailList
   * @throws Exception
   */
  public void createClaimFileCrcCIMB(EgovMap claimMap, int idx) throws Exception {

    ClaimFileCrcCIMBHandler downloadHandler = null;
    String sFile;
    String todayDate;
    String inputDate;

    try {
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01"
          : (String) claimMap.get("ctrlBatchDt");
      todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
      sFile = "CRC_" + todayDate + "_" + String.valueOf(claimMap.get("pageNo")) + ".csv";

      downloadHandler = getTextDownloadCrcCIMBHandler(sFile, claimFileColumns, null, filePath, "/CRC/CIMB/"+inputDate+"/", claimMap);

      largeExcelService.downLoadClaimFileCrcCIMB(claimMap, downloadHandler);
      // downloadHandler.writeFooter();

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
  }

  private ClaimFileCrcCIMBHandler getTextDownloadCrcCIMBHandler(String fileName, String[] columns, String[] titles,
      String path, String subPath, Map<String, Object> params) {
    FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
    excelDownloadVO.setFilePath(path);
    excelDownloadVO.setSubFilePath(subPath);
    return new ClaimFileCrcCIMBHandler(excelDownloadVO, params);
  }

  /**
   * CRC MMB - Create eCash Deduction File
   *
   * @param claimMap
   * @param claimDetailList
   * @throws Exception
   */
  public void createClaimFileCrcMBB(EgovMap claimMap) throws Exception {

    ClaimFileCrcMBBHandler downloadHandler = null;
    String sFile;
    String todayDate;
    String inputDate;

    try {
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01"
          : (String) claimMap.get("ctrlBatchDt");
      todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "yyMMdd");
      if (1 == (Integer) claimMap.get("type")) {
          sFile = "CZ" + todayDate + StringUtils.leftPad(String.valueOf(claimMap.get("pageNo")), 2, "0") + ".dat";
      } else {
          sFile = "CZ" + todayDate + "_NEW_" + claimMap.get("ctrlId") + ".dat";
      }

      downloadHandler = getTextDownloadCrcMBBHandler(sFile, claimFileColumns, null, filePath, "/CRC/MBB/"+inputDate+"/", claimMap);

      largeExcelService.downLoadClaimFileCrcMBB(claimMap, downloadHandler);
      if (claimMap.get("pageNo") == claimMap.get("pageCnt")) {
        downloadHandler.writeFooter(Integer.toString((Integer) claimMap.get("type")));
      }

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
  }

  private ClaimFileCrcMBBHandler getTextDownloadCrcMBBHandler(String fileName, String[] columns, String[] titles,
      String path, String subPath, Map<String, Object> params) {
    FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
    excelDownloadVO.setFilePath(path);
    excelDownloadVO.setSubFilePath(subPath);
    return new ClaimFileCrcMBBHandler(excelDownloadVO, params);
  }

  /**
   * CRC CIMB - Create Claim File
   *
   * @param claimMap
   * @param claimDetailList
   * @throws Exception
   */
  public void createCreditCardFileCIMB(EgovMap claimMap) throws Exception {

    CreditCardFileCIMBHandler downloadHandler = null;
    String sFile = "";
    String todayDate;
    String inputDate;

    String batchName  = claimMap.get("batchName").toString();
    String subPath = claimMap.get("subPath").toString();

    try {
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01": (String) claimMap.get("ctrlBatchDt");
      todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
      sFile = batchName + todayDate + "_" + String.valueOf(claimMap.get("pageNo")) + ".csv";

      downloadHandler = getTextDownloadCreditCardCIMBHandler(sFile, claimFileColumns, null, filePath, subPath+inputDate+"/",claimMap);

      largeExcelService.downLoadCreditCardFileCIMB(claimMap, downloadHandler);

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

   // //파일다운로드 정보 INSERT
      // claimMap.put("fileNo", 1);
      if(String.valueOf(claimMap.get("pageNo")).equals("1")){
    	  claimMap.put("filePath", subPath+batchName+"_"+claimMap.get("ctrlBatchDt")+".zip");
    	  claimMap.put("fileName", sFile);
    	  claimMap.put("fileType", "ClaimFile");

    	  claimService.insertClaimFileDownloadInfo(claimMap);
      }

    }
  }

  private CreditCardFileCIMBHandler getTextDownloadCreditCardCIMBHandler(String fileName, String[] columns,
      String[] titles, String path, String subPath, Map<String, Object> params) {
    FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
    excelDownloadVO.setFilePath(path);
    excelDownloadVO.setSubFilePath(subPath);
    return new CreditCardFileCIMBHandler(excelDownloadVO, params);
  }

  /**
   * CRC MBB - Create Claim File
   *
   * @param claimMap
   * @param claimDetailList
   * @throws Exception
   */
  public void createCreditCardFileMBB(EgovMap claimMap) throws Exception {

    CreditCardFileMBBHandler downloadHandler = null;
    String sFile;
    String todayDate;
    String inputDate;

    String batchName  = "CZ";
    String subPath = "/CRC/MBB_GROUP/";

    try {
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");

      todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "yyMMdd");

      if (1 == (Integer) claimMap.get("type")) {
          sFile = batchName + todayDate + StringUtils.leftPad(String.valueOf(claimMap.get("pageNo")), 2, "0") + ".dat";
      } else {
          sFile = batchName + todayDate + "_NEW_" + claimMap.get("ctrlId") + ".dat";
      }

      downloadHandler = getTextDownloadCreditCardMBBHandler(sFile, claimFileColumns, null, filePath, subPath+inputDate+"/", claimMap);

      largeExcelService.downLoadCreditCardFileMBB(claimMap, downloadHandler);

      if (claimMap.get("pageNo").equals(claimMap.get("pageCnt"))) {
        downloadHandler.writeFooter(Integer.toString((Integer) claimMap.get("type")));
      }
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

    claimMap.put("batchName", batchName);
    claimMap.put("subPath", subPath);
    claimMap.put("emailSubject", "SCB CRC Deduction File");

    if(String.valueOf(claimMap.get("pageNo")).equals("1")){
    	claimMap.put("filePath", subPath+batchName+"_"+claimMap.get("ctrlBatchDt")+".zip");
    	claimMap.put("fileName", sFile);
  	  claimMap.put("fileType", "ClaimFile");

    	claimService.insertClaimFileDownloadInfo(claimMap);
    }
  }

  private CreditCardFileMBBHandler getTextDownloadCreditCardMBBHandler(String fileName, String[] columns,
      String[] titles, String path, String subPath, Map<String, Object> params) {
    FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
    excelDownloadVO.setFilePath(path);
    excelDownloadVO.setSubFilePath(subPath);
    return new CreditCardFileMBBHandler(excelDownloadVO, params);
  }

  /**
   * CRC HSBC - Create Claim File
   *
   * @param claimMap
   * @param claimDetailList
   * @throws Exception
   */
  public void createCreditCardFileHSBC(EgovMap claimMap) throws Exception {
      ClaimFileGeneralHandler downloadHandler = null;
      String sFile = "";
      String sFile1 = "";
      String subPath = "";
      String subPath1 = "";
      String inputDate = "";

      Map<String, Object> map = new HashMap<String, Object>();
      LOGGER.debug("params : {}", claimMap);
      List<EgovMap> fileInfo = claimService.selectMstConf(claimMap);

      try {
          LOGGER.info("createCreditCardFileHSBC :: Start");
          if(fileInfo.size() > 0) {
              for(int i = 0; i < fileInfo.size(); i++) {
                  Map<String, Object> fileInfoConf = new HashMap<String, Object>();
                  fileInfoConf = (Map<String, Object>) fileInfo.get(i);
                  claimMap.put("ctrlConfId", fileInfoConf.get("id"));

                  // Form File Name
                  // HSBC has no file extension
                  sFile = fileInfoConf.get("ctrlFileNm").toString().replace("{0}", "_" + claimMap.get("pageNo").toString());
                  sFile1 = fileInfoConf.get("ctrlFileNm").toString().replace("{0}", "");

                  inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");
                  subPath = CommonUtils.nvl(fileInfoConf.get("ctrlSubPath")) + inputDate + "/";
                  subPath1= CommonUtils.nvl(fileInfoConf.get("ctrlSubPath"));

                  downloadHandler = getTextDownloadGeneralHandler(sFile, claimFileColumns, null, filePath, subPath, claimMap);
                  largeExcelService.downloadCreditCardFileHSBC(claimMap, downloadHandler);
              }
          }
          LOGGER.info("createCreditCardFileHSBC :: End");
      } catch(Exception ex) {
          LOGGER.debug(ex.getMessage());
          throw new ApplicationException(ex, AppConstants.FAIL);
      } finally {
          if(downloadHandler != null) {
              try {
                  downloadHandler.close();
                  LOGGER.info("createCreditCardFileHSBC :: downloadHandler :: Close");
              } catch(Exception ex) {
                  LOGGER.debug(ex.getMessage());
              }
          }

          if(String.valueOf(claimMap.get("pageNo")).equals("1")){
        	  claimMap.put("filePath", subPath1+sFile1+"_"+claimMap.get("ctrlBatchDt")+".zip");
        	  claimMap.put("fileName", sFile);
        	  claimMap.put("fileType", "ClaimFile");

        	  claimService.insertClaimFileDownloadInfo(claimMap);
          }
      }
  }

  /**
   * CRC AMB - Create Claim File
   *
   * @param claimMap
   * @param claimDetailList
   * @throws Exception
   */
  public void createCreditCardFileAMB(EgovMap claimMap) throws Exception {
      ClaimFileGeneralHandler downloadHandler = null;
      String sFile = "";
      String sFile1 = "";
      String subPath = "";
      String subPath1 = "";
      String inputDate = "";
      String todayDate = "";

      Map<String, Object> map = new HashMap<String, Object>();
      LOGGER.debug("params : {}", claimMap);
      List<EgovMap> fileInfo = claimService.selectMstConf(claimMap);

      try {
          LOGGER.info("createCreditCardFileAMB :: Start");
          if(fileInfo.size() > 0) {
              for(int i = 0; i < fileInfo.size(); i++) {
                  Map<String, Object> fileInfoConf = new HashMap<String, Object>();
                  fileInfoConf = (Map<String, Object>) fileInfo.get(i);
                  claimMap.put("ctrlConfId", fileInfoConf.get("id"));
                  String fileName = fileInfoConf.get("ctrlFileNm").toString();
                  String ext = fileInfoConf.get("ctrlFileExt").toString();
                  String batchNo = String.valueOf(claimMap.get("batchNo"));
                  String pageNo = String.valueOf(claimMap.get("pageNo"));

                  // Form File Name

                  todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
                  sFile = fileName + todayDate + "_" + batchNo + "." + ext;
                  sFile1= fileName;

                  inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) claimMap.get("ctrlBatchDt");
                  subPath = CommonUtils.nvl(fileInfoConf.get("ctrlSubPath")) + inputDate + "/";
                  subPath1 = CommonUtils.nvl(fileInfoConf.get("ctrlSubPath"));

                  downloadHandler = getTextDownloadGeneralHandler(sFile, claimFileColumns, null, filePath, subPath, claimMap);
                  largeExcelService.downloadCreditCardFileAMB(claimMap, downloadHandler);
                  downloadHandler.writeFooter();
              }
          }
          LOGGER.info("createCreditCardFileAMB :: End");
      } catch(Exception ex) {
          LOGGER.debug(ex.getMessage());
          throw new ApplicationException(ex, AppConstants.FAIL);
      } finally {
          if(downloadHandler != null) {
              try {
                  downloadHandler.close();
                  LOGGER.info("createCreditCardFileAMB :: downloadHandler :: Close");
              } catch(Exception ex) {
                  LOGGER.debug(ex.getMessage());
              }
          }

          if(String.valueOf(claimMap.get("pageNo")).equals("1")){
        	  claimMap.put("filePath", subPath1+sFile1+"_"+claimMap.get("ctrlBatchDt")+".zip");
        	  claimMap.put("fileName", sFile);
        	  claimMap.put("fileType", "ClaimFile");
        	  claimService.insertClaimFileDownloadInfo(claimMap);
          }

      }
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
      inputDate = CommonUtils.nvl(claimMap.get("ctrlBatchDt")).equals("") ? "1900-01-01"
          : (String) claimMap.get("ctrlBatchDt");
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

    // //파일다운로드 정보 INSERT
    // claimMap.put("fileNo", 1);
    // claimMap.put("filePath", fileDownloadPath+"/FPX/ClaimBank/");
    // claimMap.put("fileName", sFile);
    //
    // claimService.insertClaimFileDownloadInfo(claimMap);

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

  /**
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/initClaimFileDownPop.do")
  public String initClaimFileDownPop(@RequestParam Map<String, Object> params, ModelMap model) {

    model.put("ctrlId", params.get("ctrlId"));
    return "payment/autodebit/claimFileDownloadPop";
  }

  /**
   *
   *
   * @param params
   * @param model
   * @return
   */
  @RequestMapping(value = "/selectClaimFileDown.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectClaimFileDown(@RequestParam Map<String, Object> params, ModelMap model) {
    // 조회.
    List<EgovMap> resultList = claimService.selectClaimFileDown(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/selectClmStat.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectClmStat(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> codeList = claimService.selectClmStat(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectListing.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectListing(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> codeList = claimService.selectListing(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectAccBank.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAccBank(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> codeList = claimService.selectAccBank(params);
    return ResponseEntity.ok(codeList);
  }

  public void zipFilesEmail(EgovMap claimMap) {

    String batchName = claimMap.get("batchName").toString();
    String subPath = claimMap.get("subPath").toString();
    String batchDate = claimMap.get("ctrlBatchDt").toString();
    String emailSubject = claimMap.get("emailSubject").toString();
    String emailBody = claimMap.get("emailBody").toString();
    String fileDirectory = filePath + subPath;

    if("1".equals(String.valueOf(claimMap.get("ctrlIsCrc"))) && "17".equals(String.valueOf(claimMap.get("ctrlBankId")))) {
        // HSBC - Remove param from filename
        batchName = batchName.replace("{0}", "");
    }

      String zipFile = fileDirectory + "/" + batchName +"_" +batchDate + ".zip";
      String srcDir  = fileDirectory + "/" + batchDate;
      String subPathFile = subPath + batchName +"_" +batchDate + ".zip";

      try {

          // create byte buffer
          byte[] buffer = new byte[1024];

          FileOutputStream fos = new FileOutputStream(zipFile);
          ZipOutputStream zos = new ZipOutputStream(fos);

          File dir = new File(srcDir);
          File[] files = dir.listFiles();
          System.out.println("files "  + files);
          for (int i = 0; i < files.length; i++) {
              System.out.println("Adding file: " + files[i].getName());

              FileInputStream fis = new FileInputStream(files[i]);

              // begin writing a new ZIP entry, positions the stream to the start of the entry data
              zos.putNextEntry(new ZipEntry(files[i].getName()));

              int length;

              while ((length = fis.read(buffer)) > 0) {
                  zos.write(buffer, 0, length);
              }

              zos.closeEntry();
              // close the InputStream
              fis.close();
          }
          // close the ZipOutputStream
          zos.close();

          //Email Start
          File file = new File(zipFile);

          EmailVO email = new EmailVO();

          email.setTo(emailReceiver);
          email.setHtml(false);
          email.setSubject(emailSubject.replace("{0}", batchDate));
          email.setText(emailBody);
          email.addFile(file);

//        Date today = new Date();
//      	SimpleDateFormat format1 = new SimpleDateFormat("dd");
//      	String day = format1.format(today);
//          if(!day.equals("24")){//20240829
        	  adaptorService.sendEmail(email, false);
//          }

          claimMap.put("file", subPathFile);
      }
      catch (IOException ioe) {
          System.out.println("Error creating zip file" + ioe);
      }
  }

  @RequestMapping(value = "/initVRescueClaimList.do")
  public String initVRescueClaimList(@RequestParam Map<String, Object> params, ModelMap model) {
    return "payment/autodebit/vRescue";
  }

  @RequestMapping(value = "/selectVResClaimList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectVResClaimList(@RequestParam Map<String, Object> params, ModelMap model) {
    // 조회.
    List<EgovMap> resultList = claimService.selectVResClaimList(params);

    // 조회 결과 리턴.
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/selectVResClaimMasterById.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectVResClaimMasterById(@RequestParam Map<String, Object> params, ModelMap model) {

    EgovMap returnMap = null;
    // 조회.
    List<EgovMap> resultList = claimService.selectVResClaimList(params);

    if (resultList != null && resultList.size() > 0) {
      returnMap = resultList.get(0);

      // CONVERT DECIMAL
      if (returnMap.get("ctrlBillAmt") != null) {
        returnMap.put("ctrlBillAmt", CommonUtils.getNumberFormat(returnMap.get("ctrlBillAmt").toString(), "#,##0.00"));
      }
      if (returnMap.get("ctrlBillPayAmt") != null) {
        returnMap.put("ctrlBillPayAmt",
            CommonUtils.getNumberFormat(returnMap.get("ctrlBillPayAmt").toString(), "#,##0.00"));
      }
    } else {
      returnMap = new EgovMap();
    }

    // 조회 결과 리턴.
    return ResponseEntity.ok(returnMap);
  }

  @RequestMapping(value = "/selectVResListing.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectVResListing(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> codeList = claimService.selectVResListing(params);
    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/generateVResNewClaim.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> generateVResNewClaim(@RequestBody Map<String, ArrayList<Object>> params, Model model,
      SessionVO sessionVO) {

    List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터
                                                                   // 가져오기
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
    LOGGER.debug("new_ddtChnl : {}", claim.get("new_ddtChnl"));
    LOGGER.debug("new_issueBank : {}", claim.get("new_issueBank"));
    LOGGER.debug("new_debitDate : {}", claim.get("new_debitDate"));

    // HasActiveBatch : 동일한 bankId, Claim Type 에 해당하는 active 건이 있는지 확인한다.
    searchMap = new HashMap<String, Object>();
    searchMap.put("ddtChnl", claim.get("new_ddtChnl"));
    searchMap.put("issueBank", claim.get("new_issueBank"));
    searchMap.put("claimType", claim.get("new_claimType"));
    searchMap.put("status", "1");

    List<EgovMap> isActiveBatchList = claimService.selectVResClaimList(searchMap);

    // Active인 배치가 있는 경우
    if (isActiveBatchList.size() > 0) {
      returnCode = "IS_BATCH";
      returnMap = (Map<String, Object>) isActiveBatchList.get(0);
    } else {

      String isCRC = "131".equals((String.valueOf(claim.get("new_claimType")))) ? "1"
          : "132".equals((String.valueOf(claim.get("new_claimType")))) ? "0" : "134";
      String inputDate = CommonUtils.changeFormat(String.valueOf(claim.get("new_debitDate")), "dd/MM/yyyy", "yyyyMMdd");
      String claimDay = CommonUtils.nvl(String.valueOf(claim.get("new_claimDay")));
      String ddtChnl = CommonUtils.nvl(String.valueOf(claim.get("new_ddtChnl")));
      String bankId = CommonUtils.nvl(String.valueOf(claim.get("new_issueBank")));
      String cardType = CommonUtils.nvl(String.valueOf(claim.get("new_cardType")));
      String issueBankId = CommonUtils.nvl(String.valueOf(claim.get("hiddenIssueBank")));


      claim.put("new_claimType", isCRC);
      claim.put("new_debitDate", inputDate);
      claim.put("new_claimDay", claimDay);
      claim.put("new_ddtChnl", ddtChnl);
      claim.put("new_issueBank", bankId);
      claim.put("new_cardType", cardType);
      claim.put("new_merchantBank", issueBankId);
      claim.put("userId", sessionVO.getUserId());

      claimService.createVResClaim(claim); // 프로시저 함수 호출
      List<EgovMap> resultMapList = (List<EgovMap>) claim.get("p1"); // 결과 뿌려보기
                                                                     // : 프로시저에서
                                                                     // p1이란
                                                                     // key값으로
                                                                     // 객체를
                                                                     // 반환한다.

      if (resultMapList.size() > 0) {
        // 프로시저 결과 Map
        returnMap = (Map<String, Object>) resultMapList.get(0);

        // Calim Master 및 Detail 조회
        // EgovMap claimMasterMap = claimService.selectClaimById(returnMap);
        // List<EgovMap> claimDetailList =
        // claimService.selectClaimDetailById(returnMap);

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

  @RequestMapping(value = "/initVRescueManagement.do")
  public String initVRescueManagement(@RequestParam Map<String, Object> params, ModelMap model) {
    return "payment/autodebit/vRescueManagement";
  }

  @RequestMapping(value = "/saveVRescueUpdate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveVRescueUpdate(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

	  params.put("userId", sessionVO.getUserId());
	  claimService.saveVRescueUpdate(params);

	  ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData("");
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


		return ResponseEntity.ok(message);

	}

  private boolean requireFileEncrypt(EgovMap claimMap) {

	  if ("3".equals(String.valueOf(claimMap.get("ctrlBankId")))
			  && "0".equals(String.valueOf(claimMap.get("ctrlIsCrc")))
			  && !"3182".equals(String.valueOf(claimMap.get("ctrlDdtChl")))) {
			  return true; //only for CIMB Direct Debit (deduction channel : General)
	  }

	  return false;
  }

  private void generateEncryptFile(EgovMap claimMap) {

	  String subPath = claimMap.get("subPath").toString();
	  String batchDate = claimMap.get("ctrlBatchDt").toString();
	  String fileDirectory = filePath + subPath;

	  String srcDir  = fileDirectory + "/" + batchDate + "/";

      File dir = new File(srcDir);
      File[] files = dir.listFiles();
	  String srcFile = "";

      for (int i = 0; i < files.length; i++) {
    	  srcFile = files[i].getName();
          System.out.println("To encrypt file: " + srcFile);

		  LOGGER.debug("1. PGP encryption Start.");

		  String cmd = "";
		  String str = null;
		  StringBuffer sb = null;
		  String encryptFilePath = "";
		  String encFile = "";

		  try {
			  LOGGER.debug("1-1. PGP encryption Start.");
			  LOGGER.debug("fileName:" + srcFile);

			  String[] arr = srcFile.split("\\.");
			  encryptFilePath = filePath + subPath + arr[0] + ".GPG";
			  encFile = arr[0] + ".GPG";

			  // encrypt file exist -> delete
			  File fileEncryptDel = new File(encryptFilePath);
			  fileEncryptDel.delete();

			  cmd = "gpg --output " + encryptFilePath + " --encrypt --recipient " + CIMB_DD_KEYNAME  + " " + srcDir + srcFile ;

			  LOGGER.debug(">>>>>>>>>encrypt cmd: " + cmd);

			  // 명령행 출력 라인 캡쳐를 위한 StringBuffer 설정
			  sb = new StringBuffer();
			  // 명령 실행
			  Process proc = Runtime.getRuntime().exec(cmd);
			  // 명령행의 출력 스트림을 얻고, 그 내용을 buffered reader input stream에 입력한다.
			  BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			  // 명령행에서의 출력 라인 읽음
			  while ((str = br.readLine()) != null){
				  sb.append(str).append("\n");
				  LOGGER.debug(">>>>>>>>>" + str);
			  }

			  // 명령행이 종결되길 기다린다
			  int rtn = -9999;
			  try {
				  proc.waitFor();
				  // 종료값 체크
				  rtn = proc.exitValue();
				  LOGGER.debug( ">>>>>>>>>>>>rtn:" + rtn);
			  }catch(InterruptedException e){
				  LOGGER.error("Error encrypt file.", e);
			  }finally{
				  //stream을 닫는다
				  br.close();
			  }

			  LOGGER.debug("1-2. PGP encryption End.");

		  }catch(Exception e) {
			  LOGGER.debug("Unexpected Error:" + e.getMessage());
		  }

		  LOGGER.debug("1. PGP encryption End.");
		  claimMap.put("encFile", subPath + encFile);
      }
  }

  /*
  // YONGJH 20210421 - commented this method because it is unused
  public void zipFilesEncrypt(EgovMap claimMap) {

	  String batchName = claimMap.get("batchName").toString();
	  String subPath = claimMap.get("subPath").toString();
	  String batchDate = claimMap.get("ctrlBatchDt").toString();
	  String fileDirectory = filePath + subPath;

	  String srcDir  = fileDirectory + "/" + batchDate;
	  String zipEncryptFilePath = fileDirectory + "/" + batchName +"_" +batchDate + ".gpg";
	  String subPathZipEnc = subPath + batchName +"_" +batchDate + ".gpg";

	  String cmd = "";
	  String str = null;
	  StringBuffer sb = null;

	  LOGGER.debug("1. PGP ZIP encryption Start.");

	  try {
		  LOGGER.debug("1-1. PGP ZIP encryption Start.");

		  // encrypt file exist -> delete
		  File fileEncryptZipDel = new File(zipEncryptFilePath);
		  fileEncryptZipDel.delete();

		  File fileSrcDir = new File(srcDir);

		  cmd = "gpg-zip --encrypt --output " + zipEncryptFilePath + " --recipient " + CIMB_DD_KEYNAME  + " ." ;

		  LOGGER.debug(">>>>>>>>>encrypt cmd: " + cmd);

		  // 명령행 출력 라인 캡쳐를 위한 StringBuffer 설정
		  sb = new StringBuffer();
		  // 명령 실행
		  Process proc = Runtime.getRuntime().exec(cmd, null, fileSrcDir);
		  // 명령행의 출력 스트림을 얻고, 그 내용을 buffered reader input stream에 입력한다.
		  BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
		  // 명령행에서의 출력 라인 읽음
		  while ((str = br.readLine()) != null){
			  sb.append(str).append("\n");
			  LOGGER.debug(">>>>>>>>>" + str);
		  }

		  // 명령행이 종결되길 기다린다
		  int rtn = -9999;
		  try {
			  proc.waitFor();
			  // 종료값 체크
			  rtn = proc.exitValue();
			  LOGGER.debug( ">>>>>>>>>>>>rtn:" + rtn);

		  }catch(InterruptedException e) {
			  LOGGER.error("e", e);
		  }finally{
			  //stream을 닫는다
			  br.close();
		  }

		  LOGGER.debug("1-2. PGP ZIP encryption End.");

	  } catch (Exception e) {
		  LOGGER.debug("Unexpected Error:" + e.getMessage());
	  }

	  LOGGER.debug("1. PGP ZIP encryption End.");
      claimMap.put("encFile", subPathZipEnc);
  }
  */

  	/**
  	 *20210323 - fileDownClaim method added by Yong
  	 */
	@RequestMapping(value = "/downloadClaimFile.do", method = RequestMethod.POST)
	public void fileDownClaim(	@RequestParam("dloadPathAndName") String dloadPathAndName,
										HttpServletRequest request,
										HttpServletResponse response) throws Exception {

		LOGGER.debug("params: downloadSubPathAndName:" + dloadPathAndName);

		String[] tempArray = dloadPathAndName.split("/");
		String filename = "";

		if(tempArray.length > 0){
			int indexFileName = tempArray.length - 1;
			filename = tempArray[indexFileName];
		}

		File dFile = new File(filePath, dloadPathAndName);
		long fSize = dFile.length();

		if (fSize > 0) {
			String mimetype = "application/octet-stream";
			response.setContentType(mimetype);
			response.setHeader("Content-Disposition", "attachment;filename=" + filename);
			FileInputStream in = null;
			ServletOutputStream out = response.getOutputStream();

			try {
				in = new FileInputStream(dFile);
				FileCopyUtils.copy(in, out);
				in.close();
				out.flush();
			} catch (IOException ex) {
				LOGGER.debug("IO Exception", ex);
			} finally {
				//out.close();
			}

		} else {
			throw new FileDownException(AppConstants.FAIL, "Could not get file : " + filename);
		}
	}

	  @RequestMapping(value = "/creditCardClaimMonth2Uploads.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> creditCardClaimMonth2Uploads(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws IOException, InvalidFormatException {
	    ReturnMessage message = new ReturnMessage();

	    Map<String, MultipartFile> fileMap = request.getFileMap();
	    MultipartFile multipartFile = fileMap.get("csvFile");
	    List<M2UploadVO> vos = csvReadComponent.readCsvToList(multipartFile, true, M2UploadVO::create);

	    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	    for (M2UploadVO vo : vos) {
	      HashMap<String, Object> hm = new HashMap<String, Object>();

	      hm.put("orderNo", vo.getOrderNo());

	      list.add(hm);
	    }

	    params.put("userId", sessionVO.getUserId());

	    int result = 0;

	    	result = claimService.saveM2Upload(params,list);
	    	claimService.creditCardClaimMonth2UpateFlag(params);

	    if(result > 0){
	        message.setMessage("M2 orders successfully uploaded.<br />Item(s) uploaded : "+result);
	    }else{
	    		 message.setMessage("Failed to upload M2 item(s). Please try again later.");
	    }

	    return ResponseEntity.ok(message);
	  }

	  @RequestMapping(value = "/orderListMonthViewPop.do")
	  public ResponseEntity<List<EgovMap>> orderListMonthViewPop(@RequestParam Map<String, Object> params) {
	    List<EgovMap> resultList = claimService.orderListMonthViewPop(params);
	    return ResponseEntity.ok(resultList);
	  }

	  @RequestMapping(value = "/initVRescueBulkUpload.do")
	  public String initVRescueBulkUpload(@RequestParam Map<String, Object> params, ModelMap model) {
	    return "payment/autodebit/vRescueBulkUploadList";
	  }

	  @RequestMapping(value = "/selectVRescueBulkList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectVRescueBulkList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
	      LOGGER.debug("params =====================================>>  " + params);

	      List<EgovMap> list = claimService.selectVRescueBulkList(params);

	      LOGGER.debug("list =====================================>>  " + list.toString());
	      return ResponseEntity.ok(list);
	  }

	  @RequestMapping(value = "/selectVRescueBulkDetails.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectVRescueBulkDetails(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
	      LOGGER.debug("params =====================================>>  " + params);

	      List<EgovMap> list = claimService.selectVRescueBulkDetails(params);

	      LOGGER.debug("list =====================================>>  " + list.toString());
	      return ResponseEntity.ok(list);
	  }

	  @RequestMapping(value = "/csvVRescueBulkUpload", method = RequestMethod.POST)
	  public ResponseEntity readFile(MultipartHttpServletRequest request,SessionVO sessionVO) throws IOException, InvalidFormatException {

		  int cnt = 0;
		  ReturnMessage message = new ReturnMessage();
	      Map<String, MultipartFile> fileMap = request.getFileMap();
	      MultipartFile multipartFile = fileMap.get("csvFile");
	      List<vRescueBulkUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, true, vRescueBulkUploadVO::create);

	      List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
	      for (vRescueBulkUploadVO vo : vos) {

	          HashMap<String, Object> hm = new HashMap<String, Object>();
	          hm.put("ordNo", vo.getOrdNo().trim());
	          hm.put("remark", vo.getRemark().trim());
	          hm.put("crtUserId", sessionVO.getUserId());
	          hm.put("updUserId", sessionVO.getUserId());
	          detailList.add(hm);
	      }

	      Map<String, Object> master = new HashMap<String, Object>();
	      master.put("crtUserId", sessionVO.getUserId());
	      master.put("updUserId", sessionVO.getUserId());
	      master.put("totItem", vos.size());

	      List<String> orderList = new ArrayList<String>();
	      for (vRescueBulkUploadVO vo : vos) {

	          String hm =  vo.getOrdNo().trim();
	          orderList.add(hm);
	      }
          LOGGER.debug("Order List >>>>>>" + orderList);

          try {

			cnt = claimService.selectUnableBulkUploadList(orderList);

			if (cnt > 0){
				message.setCode(AppConstants.FAIL);
				message.setData("");
				message.setMessage("Kindly upload orders with REG paymode only");
			}
			else {
				Map<String, Object> result = claimService.saveCsvVRescueBulkUpload(master, detailList);
			      if(result.get("batchId") != null){
			          message.setMessage("vRescue Bulk Upload File successfully uploaded.<br />Batch ID : "+result.get("batchId") +"<br />Batch No : "+result.get("batchNo"));
			          message.setCode(AppConstants.SUCCESS);
			      }else{
			          message.setMessage("Failed to upload vRescue Bulk Upload File. Please try again later.");
			          message.setCode(AppConstants.FAIL);
			      }
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	      return ResponseEntity.ok(message);
	  }


	  @RequestMapping(value = "/saveVRescueBulkConfirm.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> saveVRescueBulkConfirm(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {

		  params.put("userId", sessionVO.getUserId());
	      LOGGER.debug("params =====================================>>  " + params);
		  ReturnMessage message = new ReturnMessage();

	  	  List<EgovMap> unableUploadList = claimService.selectUnableBulkUploadList2(params);
	  	  if(unableUploadList.size() > 0){
				message.setCode(AppConstants.FAIL);
				message.setData("");
				message.setMessage("Kindly upload orders with REG paymode only");
	  	  }

	  	  else {
	  		  int result = claimService.saveVRescueBulkConfirm(params);

		      if(result == 1){

					message.setCode(AppConstants.SUCCESS);
					message.setData("");
					message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		      }

		      else{
					message.setCode(AppConstants.FAIL);
					message.setData("");
					message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		      }
	  	  }

	      return ResponseEntity.ok(message);
		}

		@RequestMapping(value = "/downloadCreditCardClaimFile.do", method = RequestMethod.POST)
		public void fileDownCreditCardClaim(	@RequestParam("dloadCtrlId") String dloadCtrlId,
				@RequestParam("fileType") String fileType,
											HttpServletRequest request,
											HttpServletResponse response) throws Exception {

			Map<String, Object> params = new HashMap<String, Object>();
			params.put("ctrlId", dloadCtrlId);
			params.put("fileType", fileType);
			List<EgovMap> resultList = claimService.selectClaimFileDown(params);

			String filename = "";

			if(resultList.size() < 1){
				throw new FileDownException(AppConstants.FAIL, "Could not get file : " + filename);
			}

			String filePath1 = resultList.get(0).get("filePath").toString();
			LOGGER.debug("params: downloadSubPathAndName:" + filePath1);

			String[] tempArray = filePath1.split("/");

			if(tempArray.length > 0){
				int indexFileName = tempArray.length - 1;
				filename = tempArray[indexFileName];
			}

			File dFile = new File(filePath, filePath1);
			long fSize = dFile.length();

			if (fSize > 0) {
				String mimetype = "application/octet-stream";
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition", "attachment;filename=" + filename);
				FileInputStream in = null;
				ServletOutputStream out = response.getOutputStream();

				try {
					in = new FileInputStream(dFile);
					FileCopyUtils.copy(in, out);
					in.close();
					out.flush();
				} catch (IOException ex) {
					LOGGER.debug("IO Exception", ex);
				} finally {
					//out.close();
				}

			} else {
				throw new FileDownException(AppConstants.FAIL, "Could not get file : " + filename);
			}
		}

		public void createClaimFileExcel(EgovMap claimMap ) {//order basic credit card claim list excel

		    ClaimFileCrcDetExcelHandler downloadHandler = null;
		    String sFile;
		    String ctrlBatchDt;
		    String inputDate;

		    ExcelDownloadHandler excelDownloadHandler = null;
		    try {
		      ctrlBatchDt = (String) claimMap.get("ctrlBatchDt");
		      inputDate = CommonUtils.nvl(ctrlBatchDt).equals("") ? "1900-01-01" : ctrlBatchDt;
		      sFile = "AutoDebitDetails_" + claimMap.get("ctrlId") + "_"+ CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd") + ".xls";

		      String[] titles = new String[] {"BATCH_NO","DEBIT_DT","ORD_NO","ACCOUNT_NO","ACCOUNT_NAME","ISSUE_BANK","CARD_TYPE","AMOUNT","APPROVE_CODE","REFERENCE_NO"};

//		      String[] columns = new String[] {"BATCH_NO","DEBIT_DT","ORD_NO","ACCOUNT_NO","ACCOUNT_NAME","ISSUE_BANK","CARD_TYPE","AMOUNT","APPROVE_CODE","REFERENCE_NO"};
		      String[] columns = new String[] {"batchNo","debitDt","ordNo","accountNo","accountName","issueBank","cardType","amount","approveCode","referenceNo"};
		      ExcelDownloadVO excelDownloadVO = ExcelDownloadFormDef.getExcelDownloadVO(sFile, columns,titles);
		      downloadHandler = getTextDownloadCrcDetExcelHandler(sFile, columns, null, filePath, "/CRC/ClaimDetails/", claimMap,excelDownloadVO);

		      largeExcelService.downLoadClaimFileExcel(claimMap, downloadHandler);

//		      if(String.valueOf(claimMap.get("pageNo")).equals("1")){
		    	  claimMap.put("filePath", "/CRC/ClaimDetails/"+sFile);
		    	  claimMap.put("fileName", sFile);
		    	  claimMap.put("fileType", "Details");

		    	  claimService.insertClaimFileDownloadInfo(claimMap);
//		      }

//		      downloadHandler.writeFooter();

		      //
//				sFile = "AutoDebitDetails_" + claimMap.get("ctrlId") + "_"+ CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd") + ".xlsx";
//
//				String[] columns = new String[] { "clctrId", "ordId", "strtgOs", "closOs", "isDrop",
//						"isExclude", "runId", "taskId" };
//
//				String[]  titles = new String[] { "clctrId", "ordId", "strtgOs", "closOs", "isDrop",
//						"isExclude", "runId", "taskId" };
//
//				ExcelDownloadVO excelDownloadVO = ExcelDownloadFormDef.getExcelDownloadVO(sFile, columns,titles);
//				FileInfoVO excelDownloadVO = FormDef.getTextDownloadVO(fileName, columns, titles);
//			    excelDownloadVO.setFilePath(filePath);
//			    excelDownloadVO.setSubFilePath("/CRC/ClaimDetails/");
//				excelDownloadHandler = new ExcelDownloadHandler(excelDownloadVO, response);
//
//				Map map = new HashMap();
//				map.put("ctrlId", claimMap.get("ctrlId") );
//
//				largeExcelService.downLoadClaimFileExcel(map, excelDownloadHandler);
//		      ExcelFileGenerator

//		      Map<String, Object> map = new HashMap<String, Object>();
//	    		map.put("payDateFr", request.getParameter("payDateFr") == null ? "01/01/1900" :  request.getParameter("payDateFr"));
//	    		map.put("payDateTo", request.getParameter("payDateTo") == null ? "01/01/1900" :  request.getParameter("payDateTo"));

//	    		String[] columns;
//	            String[] titles;
//
//	            columns = new String[] {"receiptno","orderno","trxDate","name","bankAcc","debtCode","branchcode","payitemappvno","payitemchqno",
//	            		"username","description","cardmode","payitemamt","payitemremark","fpayitemccno","paymode","trNo","refNo","refDtl","crcmode",
//	            		"crctype","payitemccholdername","payitemccexpirydate","refdate","keyinby","issuedbank","deptcode","orderstatus",
//	            		"custvano","bankChgAmt","advancemth","runningno","cardtype","pvMonth","pvYear","crcStatementNo","crcStatus",
//	            		"crcStatementRemark","custcategory","custtype","transId","ordCrtDt","keyInScrn","paymentcollector","batchPayId","crcStateId"};
//
//	            titles = new String[] {"RECEIPTNO","ORDERNO","TRX_DATE","NAME","BANK_ACC","DEBT_CODE","BRANCHCODE","PAYITEMAPPVNO","PAYITEMCHQNO","USERNAME",
//	            		"DESCRIPTION","CARD_MODE","PAYITEMAMT","PAYITEMREMARK","FPAYITEMCCNO","PAYMODE","TR_NO","REF_NO","REF_DTL","CRCMODE","CRCTYPE","PAYITEMCCHOLDERNAME",
//	            		"PAYITEMCCEXPIRYDATE","REFDATE","KEYINBY","ISSUEDBANK","DEPTCODE","ORDERSTATUS","CUSTVANO","BANK_CHG_AMT","ADVANCEMTH",
//	            		"RUNNINGNO","CARDTYPE","PV_MONTH","PV_YEAR","CRC_STATEMENT_NO","CRC_STATUS","CRC_STATEMENT_REMARK","CustCategory","CustType","TRANS_ID",
//	            		"ORD_CRT_DT" ,"KEY IN SCRN" ,"PAYMENTCOLLECTOR" ,"BATCH_PAY_ID", "CRC STATE ID"};
//
//
//				downloadHandler = getExcelDownloadHandler(response, "DailyCollectionRawData.xlsx", columns, titles);
//				largeExcelService.downloadDailyCollectionRawData(map, downloadHandler);

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
//		    File file = new File(filePath + "/ALB/ClaimBank/" + sFile);
//		    EmailVO email = new EmailVO();
//
//		    email.setTo(emailReceiver);
//		    email.setHtml(false);
//		    email.setSubject("ALB Auto Debit Claim File - Batch Date : " + inputDate);
//		    email.setText("Please find attached the claim file for your kind perusal.");
//		    email.addFile(file);
//
//		    adaptorService.sendEmail(email, false);
		  }

		private ClaimFileCrcDetExcelHandler getTextDownloadCrcDetExcelHandler(String fileName, String[] columns
				, String[] titles,String path, String subPath, Map<String, Object> params,ExcelDownloadVO excelDownloadVO) {
			    FileInfoVO FileInfoVO = FormDef.getTextDownloadVO(fileName, columns, titles);
			    FileInfoVO.setFilePath(path);
			    FileInfoVO.setSubFilePath(subPath);
			    return new ClaimFileCrcDetExcelHandler(FileInfoVO, params,excelDownloadVO);
			  }
}
