package com.coway.trust.web.payment.invoice.controller;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.invoice.service.InvcNoBulkUploadVO;
import com.coway.trust.biz.payment.invoice.service.InvoiceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.config.csv.CsvReadComponent;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class InvoiceController {

	private static final Logger LOGGER = LoggerFactory.getLogger(InvoiceController.class);

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Resource(name = "invoiceService")
	private InvoiceService invoiceService;

	/**
	 * BillingMgnt 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initInvoiceStatementManagement.do")
	public String initInvoiceStatementManagement(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/statementManagement";
	}

	@RequestMapping(value = "/selectInvoiceStmtMgmtList.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceStmtMgmtList(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> list = null;

		LOGGER.debug("params : {}", params);

		if( params.get("year") != null && !("".equals(String.valueOf(params.get("year")))) && params.get("month") != null && !("".equals(String.valueOf(params.get("month")))) ){
			list = invoiceService.selectInvoiceList(params);
		}
		return ResponseEntity.ok(list);
	}

	/**
	 * Billing Result 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingConfirmedResultPop.do")
	public String initBillingConfirmedResult(@RequestParam Map<String, Object> params, ModelMap model) {

		model.addAttribute("taskId", params.get("taskId"));

		//return "payment/invoice/billingConfirmedResult";
		return "payment/invoice/billingConfirmedResultPop";
	}

	@RequestMapping(value = "/selectInvoiceResultList.do")
	public ResponseEntity<Map<String, Object>> selectInvoiceResultList(@RequestParam Map<String, Object> params, ModelMap model) {

		Map<String, Object> result = new HashMap<String, Object>();

		EgovMap master = invoiceService.selectInvoiceMaster(params).get(0);
		List<EgovMap> detail = invoiceService.selectInvoiceDetail(params);
		int totalRowCount = invoiceService.selectInvoiceDetailCount(params);

		result.put("master", master);
		result.put("detail", detail);
		result.put("totalRowCount", totalRowCount);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectInvoiceResultListPaging.do")
	public ResponseEntity<Map<String, Object>> selectInvoiceResultListPaging(@RequestParam Map<String, Object> params, ModelMap model) {

		Map<String, Object> result = new HashMap<String, Object>();
		List<EgovMap> detail = invoiceService.selectInvoiceDetail(params);

		result.put("detail", detail);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/generateInvoice.do")
	public ResponseEntity<Boolean> generateInvoice(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		boolean result = false;
		int userId = sessionVO.getUserId();

		if(userId > 0){
			params.put("userId", userId);
			invoiceService.createTaxInvoice(params);
			int resVal = Integer.parseInt(String.valueOf(params.get("p1")));

			if(resVal == 1)
				result = true;
		}

		return ResponseEntity.ok(result);
	}

  @RequestMapping(value = "/initMonthlyEStatementRaw.do")
  public String initMonthlyEStatementRaw(@RequestParam Map<String, Object> params, ModelMap model) {
    return "payment/invoice/monthlyEStatementRawData";
  }

  @RequestMapping(value = "/selecteStatementRawList.do")
  public ResponseEntity<List<EgovMap>> selecteStatementRawList(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> list = null;

    LOGGER.debug("selecteStatementRawList params : {}", params);
    if (params.get("year") != null && !("".equals(String.valueOf(params.get("year")))) && params.get("month") != null && !("".equals(String.valueOf(params.get("month"))))) {
      list = invoiceService.selecteStatementRawList(params);
    }
    return ResponseEntity.ok(list);
  }

	@RequestMapping(value = "/processBulkBatch.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> processBulkBatch(MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {
        LOGGER.debug("========== processBulkBatch.do ==========");

        final String amtRegExp = "(([1-9]\\d{0,2}(,\\d{3})*)|(([1-9]\\d*)?\\d))(\\.\\d\\d)?$";
        final String amtRegExp1 = "(([1-9]\\d{0,2}(,\\d{3})*)|(([1-9]\\d*)?\\d))(\\.\\d)?$";

        String result = AppConstants.SUCCESS;
        ReturnMessage message = new ReturnMessage();

        String seq = request.getParameter("currSeq");

        EgovMap item = new EgovMap();

        Map<String, MultipartFile> fileMap = request.getFileMap();
        MultipartFile multipartFile = fileMap.get("csvFile");

        List<InvcNoBulkUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, true, InvcNoBulkUploadVO::create);

        Map<String, Object> cvsParam = new HashMap<String, Object>();
        cvsParam.put("voList", vos);
        cvsParam.put("userId", sessionVO.getUserId());

        List<InvcNoBulkUploadVO> vos2 = (List<InvcNoBulkUploadVO>) cvsParam.get("voList");

        List<Map> invcList = vos2.stream().map(r -> {
            Map<String, Object> map = BeanConverter.toMap(r);

            map.put("grpSeq", r.getDocNo());
            map.put("invcNo", r.getInvcNo());

            return map;
        }).collect(Collectors.toList());

        int line = 1;
        int errLines = 0;
        String invalidMsg = "";
        String invalidMsgDtl = "";
        String validMsg = "";
        String msg = "";
        Map<String, Object> hm = null;

        for(Object map : invcList) {
            LOGGER.debug("========== processBulkBatch.do :: check details :: "+ line + " ==========");
            hm = (HashMap<String, Object>) map;

            String grpSeq = (String.valueOf(hm.get("grpSeq"))).trim();
            String invcNo = (String.valueOf(hm.get("invcNo"))).trim();

            LOGGER.debug("========== docNo ==========");
            if("".equals(grpSeq) || grpSeq == null || grpSeq == "null") {
                invalidMsgDtl += " Doc No";
            }

            LOGGER.debug("========== invcNo ==========");
            if("".equals(invcNo) || invcNo == null || invcNo == "null" || invcNo.length() == 1) {
                if(invalidMsgDtl.isEmpty() || invalidMsgDtl == "") {
                    invalidMsgDtl += "Invoice No";
                } else {
                    invalidMsgDtl += ", Invoice No";
                }
            }

            if(!"".equals(invalidMsgDtl)) {
                if(invalidMsg == "") {
                    invalidMsg = "Line " + line + " - " + invalidMsgDtl;
                } else {
                    invalidMsg += "<br />Line " + line + " - " + invalidMsgDtl;
                }

                invalidMsgDtl = "";
                errLines++;
            }

            line++;
        }

        if(errLines != 0) {
            result = AppConstants.FAIL;
        }

        if("".equals(seq) || seq == null) {
            item = invoiceService.getUploadSeq();
            seq = item.get("seq").toString();
        }

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
                    invoiceService.insertBulkInvc(bulkMap);
                }
            }

            validMsg = "Total Invoices : " + invcList.size() + "<br /><br />Are you sure want to process this batch ?<br />";
        }

        msg = result == AppConstants.SUCCESS ? validMsg : invalidMsg ;

        message.setMessage(msg);
        message.setCode(result);
        message.setData(seq);

        return ResponseEntity.ok(message);
    }

	@RequestMapping(value = "/uploadResultList")
    public ResponseEntity<EgovMap> uploadResultList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception{

        LOGGER.debug("uploadResultList params : {} " + params);
        EgovMap result = new EgovMap();

        List<EgovMap> resultList = null;
        resultList = invoiceService.selectUploadResultList(params);

        result.put("resultList", resultList);

        return ResponseEntity.ok(result);
    }

	@RequestMapping(value = "/selecteStatementRawListbyBatch.do")
	  public ResponseEntity<List<EgovMap>> selecteStatementRawListbyBatch(@RequestParam Map<String, Object> params, ModelMap model) {
	    List<EgovMap> list = null;

	    LOGGER.debug("selecteStatementRawListbyBatch params : {}", params);
	    list = invoiceService.selecteStatementRawListbyBatch(params);
	    return ResponseEntity.ok(list);
	  }

}
