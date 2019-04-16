package com.coway.trust.web.eAccounting.paymentUpload;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.paymentUpload.BulkUploadService;
import com.coway.trust.biz.eAccounting.paymentUpload.InvcBulkUploadVO;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceApplication;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/paymentUpload")
public class BulkUploadController {

    private static final Logger LOGGER = LoggerFactory.getLogger(BulkUploadController.class);

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    @Autowired
    private BulkUploadService bulkUploadService;

    @Autowired
    private CsvReadComponent csvReadComponent;

    @Autowired
    private WebInvoiceApplication webInvoiceApplication;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Resource(name = "webInvoiceService")
    private WebInvoiceService webInvoiceService;

    @RequestMapping(value = "/bulkInvoicesUpload.do")
    public String bulkInvoicesUpload(@RequestParam Map<String, Object> params, ModelMap model) {
        LOGGER.debug("========== bulkInvoicesUpload.do ==========");
        return "eAccounting/paymentUpload/bulkInvoiceUpload";
    }

    @RequestMapping(value = "/newBulkUploadPop.do")
    public String newBatchUploadPop(@RequestParam Map<String, Object> params, ModelMap model) {
        LOGGER.debug("========== newBulkUploadPop.do ==========");
        return "eAccounting/paymentUpload/newBulkUploadPop";
    }

    @RequestMapping(value = "/newBulkUploadResultPop.do")
    public String newBulkUploadResultPop(@RequestParam Map<String, Object> params, ModelMap model) {
        LOGGER.debug("========== newBulkUploadResultPop.do ==========");
        return "eAccounting/paymentUpload/newBulkUploadResultPop";
    }

    @RequestMapping(value = "/processBulkInvoice.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> processBulkInvoice(MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== processBulkInvoice.do ==========");

        String result = AppConstants.SUCCESS;
        ReturnMessage message = new ReturnMessage();

        int streamSeq = 1;
        String seq = request.getParameter("currSeq");
        EgovMap item = new EgovMap();
        Map<String, Object> itemMap = new HashMap<String, Object>();

        Map<String, MultipartFile> fileMap = request.getFileMap();
        MultipartFile multipartFile = fileMap.get("csvFile");
        List<InvcBulkUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, true, InvcBulkUploadVO::create);

        Map<String, Object> cvsParam = new HashMap<String, Object>();
        cvsParam.put("voList", vos);
        cvsParam.put("userId", sessionVO.getUserId());

        List<InvcBulkUploadVO> vos2 = (List<InvcBulkUploadVO>) cvsParam.get("voList");

        AtomicInteger atomicInteger = new AtomicInteger(0);

        List<Map> invcList = vos2.stream().map(r -> {
            Map<String, Object> map = BeanConverter.toMap(r);

            atomicInteger.getAndIncrement();
            LOGGER.debug("Stream seq :: " + atomicInteger.get());

            //map.put("grpSeq", Integer.toString(streamSeq));
            map.put("grpSeq", r.getDocNo());
            map.put("costCentr", r.getCostCentr());
            map.put("invcDt", r.getInvcDt());
            map.put("invcNo", r.getInvcNo());
            map.put("payDueDt", r.getPayDueDt());
            map.put("billPeriodFr", r.getBillPeriodFr());
            map.put("billPeriodTo", r.getBillPeriodTo());
            map.put("amt", r.getAmt());
            map.put("expDesc", r.getExpDesc());
            map.put("utilNo", r.getUtilNo());
            map.put("jPayNo", r.getJPayNo());

            Map<String, Object> hm = new HashMap();
            hm.put("bgtCd", r.getBgtCd());
            hm.put("supplier", r.getSupplier());
            hm.put("costCentr", r.getCostCentr());

            EgovMap contentDtls = new EgovMap();

            contentDtls = (EgovMap) bulkUploadService.getSupplierDtls(hm);
            if(contentDtls == null) {
                message.setMessage("Invalid supplier code at Line " + atomicInteger.get());
            } else {
                map.put("supplier", contentDtls.get("memAccId"));
                map.put("supplierNm", contentDtls.get("memAccName"));
            }

            contentDtls = (EgovMap) bulkUploadService.getCcDtls(hm);
            if(contentDtls == null) {
                message.setMessage("Invalid cost center code at Line " + atomicInteger.get());
            } else {
                map.put("costCentrNm", contentDtls.get("costCenterText"));
            }

            contentDtls = (EgovMap) bulkUploadService.getBgtDtls(hm);
            if(contentDtls == null) {
                message.setMessage("Invalid Budget code at Line " + atomicInteger.get());
            } else {
                map.put("bgtCd", contentDtls.get("budgetCode"));
                map.put("bgtNm", contentDtls.get("budgetCodeText"));
            }

            contentDtls = (EgovMap) bulkUploadService.getGLDtls(hm);
            if(contentDtls == null) {
                message.setMessage("Invalid Cost Center or Budget Code for GL Code at Line " + atomicInteger.get());
            } else {
                map.put("glAccNo", contentDtls.get("glAccCode"));
                map.put("glAccNm", contentDtls.get("glAccDesc"));
                map.put("cntrlType", contentDtls.get("cntrlType"));
            }

            return map;
        }).collect(Collectors.toList());

        int line = 1;
        String invalidMsg = "";
        String validMsg = "";
        String msg = "";

        Map<String, Object> hm = null;
        for(Object map : invcList) {
            LOGGER.debug("========== processBulkInvoice.do :: check details :: "+ line + " ==========");
            hm = (HashMap<String, Object>) map;

            String grpSeq = (String.valueOf(hm.get("grpSeq"))).trim();
            String costCenter = (String.valueOf(hm.get("costCentr"))).trim();
            String memAccId = (String.valueOf(hm.get("supplier"))).trim();
            String invcDt = (String.valueOf(hm.get("invcDt"))).trim();
            String invcNo = (String.valueOf(hm.get("invcNo"))).trim();
            String payDueDt = (String.valueOf(hm.get("payDueDt"))).trim();
            String budgetCode = (String.valueOf(hm.get("bgtCd"))).trim();
            Double amt = Double.parseDouble((String.valueOf(hm.get("amt"))).trim());
            String expDesc = (String.valueOf(hm.get("expDesc"))).trim();

            // Queried variables
            String glAcc = (String.valueOf(hm.get("glAccNo"))).trim();
            String cntrlType = (String.valueOf(hm.get("cntrlType"))).trim();

            // Reassigned variable for invoice number checking purpose
            hm.put("memAccId", memAccId);

            LOGGER.debug("========== docNo ==========");
            if("".equals(grpSeq) || grpSeq == null || grpSeq == "null") {
                invalidMsg = "Invalid Doc No at Line : " + line + "<br />";
                result = AppConstants.FAIL;
                break;
            }

            LOGGER.debug("========== costCenter ==========");
            if("".equals(costCenter) || costCenter == null || costCenter == "null") {
                invalidMsg = "Invalid Cost Center at Line : " + line + "<br />";
                result = AppConstants.FAIL;
                break;
            }

            LOGGER.debug("========== memAccId ==========");
            if("".equals(memAccId) || memAccId == null || memAccId == "null") {
                invalidMsg = "Invalid Supplier Code at Line : " + line + "<br />";
                result = AppConstants.FAIL;
                break;
            }

            LOGGER.debug("========== invcDt ==========");
            if("".equals(invcDt) || invcDt == null || invcDt == "null") {
                invalidMsg = "Invalid Invoice Date at Line : " + line + "<br />";
                result = AppConstants.FAIL;
                break;
            } else {
                if(invcDt.length() != 8) {
                    invalidMsg = "Invalid Invoice Date format at Line : " + line + "<br />";
                    result = AppConstants.FAIL;
                    break;
                }
            }

            LOGGER.debug("========== payDueDt ==========");
            if("".equals(payDueDt) || payDueDt == null || payDueDt == "null") {
                invalidMsg = "Invalid Payment Due Date at Line : " + line + "<br />";
                result = AppConstants.FAIL;
                break;
            } else {
                if(payDueDt.length() != 8) {
                    invalidMsg = "Invalid Payment Due Date format at Line : " + line + "<br />";
                    result = AppConstants.FAIL;
                    break;
                }
            }

            LOGGER.debug("========== budgetCode ==========");
            if("".equals(budgetCode) || budgetCode == null || budgetCode == "null") {
                invalidMsg = "Invalid Budget Code at Line : " + line + "<br />";
                result = AppConstants.FAIL;
                break;
            }

            LOGGER.debug("========== glAcc ==========");
            if("".equals(glAcc) || glAcc == null || glAcc == "null") {
                invalidMsg = "Invalid Cost Center and/or Budget Code at Line : " + line + "<br />";
                result = AppConstants.FAIL;
                break;
            }

            LOGGER.debug("========== cntrlType ==========");
            if(!"".equals(cntrlType) || cntrlType != null || cntrlType != "null") {
                if("Y".equals(cntrlType)) {
                    invalidMsg = "Budget Code is of Controlled Type at Line : " + line + "<br />";
                    result = AppConstants.FAIL;
                    break;
                }
            }

            LOGGER.debug("========== invcNo ==========");
            if(!"".equals(invcNo) || invcNo != null || invcNo != "null") {
                String claimNo = webInvoiceService.selectSameVender(hm);
                if(!"".equals(claimNo) && claimNo != null) {
                    invalidMsg = "Same invoice number exist at Line : " + line + "<br />";
                    result = AppConstants.FAIL;
                    break;
                }
            } else {
                invalidMsg = "Invoice number at Line : " + line + " is emtpy<br />";
                result = AppConstants.FAIL;
                break;
            }

            LOGGER.debug("========== amt ==========");
            if(amt < 0 || amt == null) {
                invalidMsg = "Invalid amount at Line : " + line + "<br />";
                result = AppConstants.FAIL;
                break;
            }

            LOGGER.debug("========== expDesc ==========");
            if("".equals(expDesc) || expDesc == null || expDesc == "null") {
                invalidMsg = "Invalid expenses description at Line : " + line + "<br />";
                result = AppConstants.FAIL;
                break;
            } else {
                if(expDesc.length() > 100) {
                    invalidMsg = "Maximum 100 characters allowed for expenses description at Line : " + line + "<br />";
                    result = AppConstants.FAIL;
                    break;
                }
            }

            LOGGER.debug("========== Utilities Budget ==========");
            if("06149".equals(budgetCode) || "06214".equals(budgetCode) || "06150".equals(budgetCode) || "06151".equals(budgetCode) ||
               "06211".equals(budgetCode) || "06116".equals(budgetCode) || "06152".equals(budgetCode) || "06137".equals(budgetCode) ||
               "06148".equals(budgetCode) || "06157".equals(budgetCode)) {

                String billPeriodFr = (String.valueOf(hm.get("billPeriodFr"))).trim();
                String billPeriodTo = (String.valueOf(hm.get("billPeriodTo"))).trim();

                LOGGER.debug("========== Utilities Budget :: billPeriodFr ==========");
                if("".equals(billPeriodFr)) {
                    invalidMsg = "Invalid billPeriodFr at Line : " + line + "<br />";
                    result = AppConstants.FAIL;
                    break;
                } else {
                    if(billPeriodFr.length() != 8) {
                        invalidMsg = "Invalid billPeriodFr format at Line : " + line + "<br />";
                        result = AppConstants.FAIL;
                        break;
                    }
                }

                LOGGER.debug("========== Utilities Budget :: billPeriodTo ==========");
                if("".equals(billPeriodTo)) {
                    invalidMsg = "Invalid billPeriodTo at Line : " + line + "<br />";
                    result = AppConstants.FAIL;
                    break;
                } else {
                    if(billPeriodTo.length() != 8) {
                        invalidMsg = "Invalid billPeriodTo format at Line : " + line + "<br />";
                        result = AppConstants.FAIL;
                        break;
                    }
                }
            }



            line++;
        }

        if("".equals(seq) || seq == null) {
            item = bulkUploadService.getUploadSeq();
            seq = item.get("seq").toString();
        }
        itemMap.put("seq", seq);
        bulkUploadService.clearBulkInvcTemp(itemMap);

        if(result != AppConstants.FAIL) {
            int size = 500;
            int page = invcList.size() / size;
            int start;
            int end;

            Map<String, Object> bulkMap = new HashMap<>();
            for(int i = 0; i <= page; i++) {
                start = i * size;
                end = size;

                if(i == page) {
                    end = invcList.size();
                }

                bulkMap.put("seq", seq);
                bulkMap.put("userId", sessionVO.getUserId());

                if(invcList.stream().skip(start).limit(end).count() != 0){
                    bulkMap.put("list", invcList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
                    bulkUploadService.insertBulkInvc(bulkMap);
                }
            }

            validMsg = "Total Invoices : " + invcList.size() + "<br /><br />Are you sure want to confirm this batch ?<br />";
        }

        msg = result == AppConstants.SUCCESS ? validMsg : invalidMsg ;

        message.setMessage(msg);
        message.setCode(result);
        message.setData(seq);

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/uploadResultList")
    public ResponseEntity<EgovMap> uploadResultList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

        LOGGER.debug("========== uploadResultList ==========");

        params.put("budgetDocNo", params.get("pBudgetDocNo"));

        LOGGER.debug("params ==========>>  " + params);
        EgovMap result = new EgovMap();

        List<EgovMap> resultList = null;
        resultList = bulkUploadService.selectUploadResultList(params);

        result.put("resultList", resultList);

        if(params.containsKey("atchFileGrpId")) {
            String atchFileGrpId = params.get("atchFileGrpId").toString();
            List<EgovMap> webInvoiceAttachList = webInvoiceService.selectAttachList(atchFileGrpId);

            result.put("attachmentList", webInvoiceAttachList);
        }

        if(params.containsKey("batchId")) {
            List<EgovMap> item = bulkUploadService.getApprDtl(params);
            EgovMap itemDetail = item.get(0);

            //appvLineInfo
            itemDetail = item.get(0);
            ArrayList<String> appvPrcssStusList = new ArrayList<String>();
            String appvPrcssStus = "- Request By " + (String) itemDetail.get("reqstUserId") + " [" + (String) itemDetail.get("reqstDt") + "]";

            appvPrcssStusList.add("- Request By " + (String) itemDetail.get("reqstUserId") + " [" + (String) itemDetail.get("reqstDt") + "]");

            for(int i = 0; i < item.size(); i++) {
                itemDetail = item.get(i);

                if("R".equals((String)itemDetail.get("appvStus")) || "T".equals((String)itemDetail.get("appvStus"))) {
                    appvPrcssStusList.add("- Pending By " + itemDetail.get("appvLineUserName") + " [" + itemDetail.get("appvDt") + "]");
                } else if("A".equals((String)itemDetail.get("appvStus"))) {
                    appvPrcssStusList.add("- Approved By " + itemDetail.get("appvLineUserName") + " [" + itemDetail.get("appvDt") + "]");
                } else if("J".equals((String)itemDetail.get("appvStus"))) {
                    appvPrcssStusList.add("- Rejected By " + itemDetail.get("appvLineUserName") + " [" + itemDetail.get("appvDt") + "]");
                }
            }

            result.put("appvPrcssStus", appvPrcssStusList);
        }

        return ResponseEntity.ok(result);
    }

    @RequestMapping(value="/clearTempResults", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> clearTempResults(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

        LOGGER.debug("========== clearTempResults ==========");
        LOGGER.debug("params ==========>>  " + params);

        LOGGER.debug(params.get("seq").toString());
        bulkUploadService.clearBulkInvcTemp(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> attachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

        LOGGER.debug("========== attachmentUpload ==========");
        LOGGER.debug("params ==========>>  " + params);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "eAccounting" + File.separator + "bulkInvoices", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        LOGGER.debug("list.size : {}", list.size());

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        if (list.size() > 0) {
            webInvoiceApplication.insertWebInvoiceAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        params.put("attachmentList", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/confirmBulkInvc.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> bulkInsert(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== bulkInsert ==========");
        LOGGER.debug("params ==========>>  " + params);

        int seq = 0;
        String batchId = "";
        String appvPrcssNo = "";
        String claimNo = "";
        String clamUn = "";
        String grpSeq = "";

        params.put("clmType", "J1");

        EgovMap item = new EgovMap();
        Map<String, Object> itemMap = new HashMap<String, Object>();

        item = bulkUploadService.getBatchSeq();
        batchId = item.get("seq").toString();

        List<EgovMap> bulkDetailsList = bulkUploadService.getBulkDetails(params);

        for(int i = 0; i < bulkDetailsList.size(); i++) {
            Map<String, Object> bulkDetail = (Map<String, Object>) bulkDetailsList.get(i);

            if(i == 0) {
                claimNo = webInvoiceService.selectNextClmNo();
                grpSeq = bulkDetail.get("grpSeq").toString();
            }

            if(!grpSeq.equals(bulkDetail.get("grpSeq").toString())) {
                claimNo = webInvoiceService.selectNextClmNo();
                seq = 1;
                grpSeq = bulkDetail.get("grpSeq").toString();
            } else {
                seq++;
            }

            String invcDt, payDt;
            String billPeriodFr = "";
            String billPeriodTo = "";
            invcDt = bulkDetail.get("invcDt").toString().substring(0, 10);
            payDt = bulkDetail.get("payDt").toString().substring(0, 10);

            if(bulkDetail.containsKey("billPeriodFr") && bulkDetail.containsKey("billPeriodTo")) {
                billPeriodFr = bulkDetail.get("billPeriodFr").toString().substring(0, 10);
                billPeriodTo = bulkDetail.get("billPeriodTo").toString().substring(0, 10);
            }

            item = webInvoiceService.selectClamUn(params);
            clamUn = item.get("clamUn").toString();
            params.put("clamUn", clamUn);
            webInvoiceService.updateClamUn(params);

            bulkDetail.put("batchId", batchId);
            bulkDetail.put("clmNo", claimNo);
            bulkDetail.put("seq", seq);
            bulkDetail.put("invcDt", invcDt);
            bulkDetail.put("payDt", payDt);
            bulkDetail.put("billPeriodFr", billPeriodFr);
            bulkDetail.put("billPeriodTo", billPeriodTo);
            bulkDetail.put("clamUn", clamUn);
            bulkDetail.put("userId", sessionVO.getUserId());

            bulkUploadService.insertBulkDetail(bulkDetail);

            if(i == bulkDetailsList.size() - 1) {
                appvPrcssNo = webInvoiceService.selectNextAppvPrcssNo();

                Map<String, Object> hm = null;
                List<Object> apprGridList = (List<Object>) params.get("apprLineGrid");

                for (Object map : apprGridList) {
                    hm = (HashMap<String, Object>) map;
                    hm.put("appvPrcssNo", appvPrcssNo);
                    hm.put("approveNo", (String.valueOf(hm.get("approveNo"))).trim());
                    hm.put("memCode", (String.valueOf(hm.get("memCode"))).trim());
                    hm.put("userId", sessionVO.getUserId());
                    LOGGER.debug("insertApproveLineDetail =====================================>>  " + hm);
                    // TODO appvLineDetailTable Insert
                    bulkUploadService.insertApproveLineDetail(hm);

                }

                params.put("appvPrcssNo", appvPrcssNo);
                params.put("clmNo", batchId);
                params.put("userName", sessionVO.getUserName());
                params.put("userId", sessionVO.getUserId());
                params.put("appvLineCnt", apprGridList.size());
                bulkUploadService.insertApproveManagement(params);

                int totCnt = i + 1;
                params.put("totCnt", totCnt);
                params.put("batchId", batchId);
                bulkUploadService.insertBulkMaster(params);
            }
        }

        bulkUploadService.clearBulkInvcTemp(params);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/selectBulkInvcList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectBulkInvcList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("========== selectBulkInvcList ==========");
        LOGGER.debug("params ==========>>  " + params);

        String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");

        params.put("appvPrcssStus", appvPrcssStus);

        List<EgovMap> list = bulkUploadService.selectBulkInvcList(params);

        return ResponseEntity.ok(list);
    }

    @RequestMapping(value="/getAppvInfo.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> getAppvInfo(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {

        LOGGER.debug("========== getAppvInfo ==========");
        LOGGER.debug("params ==========>>  " + params);

        ReturnMessage message = new ReturnMessage();

        boolean result = true;

        String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
        params.put("memCode", memCode);

        EgovMap apprDtls = new EgovMap();
        apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);
        List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
        List<String> appvLineUserId = new ArrayList<>();
        for(int i = 0; i < appvLineInfo.size(); i++) {
            EgovMap info = appvLineInfo.get(i);
            appvLineUserId.add(info.get("appvLineUserId").toString());
        }

        // IF approval does not contain current action user's member code then put approval group code
        if(!appvLineUserId.contains(memCode) && memCode != null) {
            params.put("apprGrp", apprDtls.get("apprGrp"));
        }

        // Check approval line contains any members from approval group
        int returnData = webInvoiceService.selectAppvStus(params);

        if(returnData > 0) {
            result = false;
        }

        // if found approval line contains member of approval group
        if(!result) {
            message.setCode(AppConstants.FAIL);
            message.setMessage("Action not allowed!");
        } else {
            Map<String, Object> hm = new HashMap<String, Object>();

            params.put("view", "APPV");

            apprDtls = (EgovMap) bulkUploadService.getApprDtls(params);
            //bulkUploadService.getApprDtls(params);

            //String appvPrcssStus = apprDtls.get("appvPrcssStus").toString();
            String appvLineCnt = apprDtls.get("appvLineCnt").toString();
            String appvLinePrcssCnt = apprDtls.get("appvLinePrcssCnt").toString();
            String appvLineSeq = apprDtls.get("appvLineSeq").toString();
            String appvStus = apprDtls.get("appvStus").toString();

            hm.put("appvPrcssNo", params.get("appvPrcssNo"));
            if(Integer.parseInt(appvLineCnt) > Integer.parseInt(appvLineSeq) + 1) {
                if("J".equals(params.get("appvStus"))) {
                    hm.put("appvPrcssStus", "J");
                } else {
                    hm.put("appvPrcssStus", "P");
                }
            } else {
                if("A".equals(params.get("appvStus"))) {
                    hm.put("appvPrcssStus", "A");
                } else if("J".equals(params.get("appvStus"))) {
                    hm.put("appvPrcssStus", "J");
                }
            }

            hm.put("appvLinePrcssCnt", Integer.parseInt(appvLinePrcssCnt) + 1);
            hm.put("userId", sessionVO.getUserId());

            bulkUploadService.updateMasterAppr(hm);

            if(!"A".equals(appvStus) || !"J".equals(appvStus)) {
                hm.put("appvStus", params.get("appvStus"));
                hm.put("appvLineSeq", Integer.parseInt(appvLineSeq));
                bulkUploadService.updateDetailAppr(hm);

                if((Integer.parseInt(appvLineCnt) > Integer.parseInt(appvLineSeq)) && !"J".equals(params.get("appvStus"))) {
                    hm.put("appvStus", "R");
                    hm.put("appvLineSeq", Integer.parseInt(appvLineSeq) + 1);
                    bulkUploadService.updateDetailAppr(hm);
                }
            }

            if(Integer.parseInt(appvLineCnt) == Integer.parseInt(appvLineSeq)) {
                List<EgovMap> bulkDetailsList = bulkUploadService.getBulkItfDtls(params);

                for(int i = 0; i < bulkDetailsList.size(); i++) {
                    Map<String, Object> bulkDetail = (Map<String, Object>) bulkDetailsList.get(i);

                    String ifKey = webInvoiceService.selectNextAppvIfKey();

                    bulkDetail.put("ifKey", ifKey);
                    bulkDetail.put("userId", sessionVO.getUserId());

                    bulkUploadService.insertBulkItf(bulkDetail);
                }
            }

            message.setCode(AppConstants.SUCCESS);
        }

        return ResponseEntity.ok(message);
    }
}
