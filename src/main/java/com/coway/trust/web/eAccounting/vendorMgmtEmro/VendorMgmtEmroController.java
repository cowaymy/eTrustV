package com.coway.trust.web.eAccounting.vendorMgmtEmro;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.eAccounting.vendorMgmtEmro.VendorMgmtEmroService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/vendorMgmtEmro")
public class VendorMgmtEmroController {

    private static final Logger LOGGER = LoggerFactory.getLogger(VendorMgmtEmroController.class);

    @Autowired
    private WebInvoiceService webInvoiceService;

    @Autowired
    private VendorMgmtEmroService vendorMgmtEmroService;

    @Value("${web.resource.upload.file}")
    private String uploadDir;

    // DataBase message accessor....
    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Autowired
    private SessionHandler sessionHandler;

    @RequestMapping(value = "/vendorMgmtEmro.do")
    public String vendorMgmtEmro(@RequestParam Map<String, Object> params, ModelMap model) {
        if (params != null) {
            String clmNo = (String) params.get("clmNo");
            model.addAttribute("clmNo", clmNo);
        }

        return "eAccounting/vendorMgmtEmro/vendorMgmtEmro";
    }

    @RequestMapping(value = "/selectVendorList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectVendorList(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();

        if (!"A1101".equals(costCentr)) {
            params.put("loginUserId", sessionVO.getUserId());
        }

        LOGGER.debug("params =====================================>>  " + params);

        String[] appvPrcssStus = request.getParameterValues("appvPrcssStus");
        //int countAppvPrcssStus = appvPrcssStus.length;
        int countAppvPrcssStus = (appvPrcssStus == null || appvPrcssStus.length == 0) ? 0 : appvPrcssStus.length;

        params.put("appvPrcssStus", appvPrcssStus);
        LOGGER.debug("countAppvPrcssStus =====================================>>  " + countAppvPrcssStus);
        params.put("countAppvPrcssStus", countAppvPrcssStus);

        String[] vendorTypeCmb = request.getParameterValues("vendorTypeCmb");
        params.put("vendorTypeCmb", vendorTypeCmb);

        String[] syncStatus = request.getParameterValues("syncStatus");
        params.put("syncStatus", syncStatus);

        List<EgovMap> list = vendorMgmtEmroService.selectVendorList(params);

        LOGGER.debug("params =====================================>>  " + list.toString());

        return ResponseEntity.ok(list);
    }

    @RequestMapping(value = "/MvendorRqstViewPop.do")
    public String MvendorRqstViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
        LOGGER.debug("params =====================================>>  " + params);
        String vendorAccId = (String) params.get("vendorAccId");
        EgovMap vendorInfo = vendorMgmtEmroService.selectVendorInfoMaster(vendorAccId);

        LOGGER.debug("vendorInfo =====================================>>  " + vendorInfo);

        List<EgovMap> bankList = vendorMgmtEmroService.selectBank();
        List<EgovMap> countryList = vendorMgmtEmroService.selectSAPCountry();

        if (params.containsKey("costCenter")) {
            model.addAttribute("costCenterName", params.get("costCenterName").toString());
            model.addAttribute("costCenter", params.get("costCenter").toString());
        }

        model.addAttribute("bankList", bankList);
        model.addAttribute("countryList", countryList);

        model.addAttribute("vendorInfo", vendorInfo);

        if(vendorInfo.containsKey("emroUpdName")){
        	String syncToEmroUsername = "By " + vendorInfo.get("emroUpdName").toString() + " [" +vendorInfo.get("emroUpdDate") + "]";
            model.addAttribute("updateUserName", syncToEmroUsername);
        }

        LOGGER.debug("vendorInfo =====================================>>  " + vendorInfo);
        return "eAccounting/vendor/vendorRequestViewMasterPop";
    }

    @RequestMapping(value = "/vendorRqstViewPop.do")
    public String vendorRqstViewPop(@RequestParam Map<String, Object> params, ModelMap model) {

        LOGGER.debug("params =====================================>>  " + params);

        List<EgovMap> appvLineInfo = webInvoiceService.selectAppvLineInfo(params);
        for (int i = 0; i < appvLineInfo.size(); i++) {
            EgovMap info = appvLineInfo.get(i);
            if ("J".equals(info.get("appvStus"))) {
                String rejctResn = webInvoiceService.selectRejectOfAppvPrcssNo(info);
                model.addAttribute("rejctResn", rejctResn);
            }
        }
        List<EgovMap> appvInfoAndItems = webInvoiceService.selectAppvInfoAndItems(params);

        List<EgovMap> bankList = vendorMgmtEmroService.selectBank();
        List<EgovMap> countryList = vendorMgmtEmroService.selectSAPCountry();

        // Approval Status 생성
        String appvPrcssStus = webInvoiceService.getAppvPrcssStus(appvLineInfo, appvInfoAndItems);

        // VANNIE ADD TO GET FILE GROUP ID, FILE ID AND FILE COUNT.
        List<EgovMap> atchFileData = webInvoiceService.selectAtchFileData(params);
        String reqNo = (String) params.get("reqNo");
        EgovMap vendorInfo = vendorMgmtEmroService.selectVendorInfo(reqNo);

        if(atchFileData.isEmpty()) {
            model.addAttribute("atchFileCnt", 0);
        } else {
            model.addAttribute("atchFileCnt", atchFileData.get(0).get("fileCnt"));
        }

        String atchFileGrpId = String.valueOf(vendorInfo.get("atchFileGrpId"));
        if(atchFileGrpId != "null") {
            List<EgovMap> vendorAttachList = vendorMgmtEmroService.selectAttachList(atchFileGrpId);
            model.addAttribute("attachmentList", vendorAttachList);
            LOGGER.debug("attachmentList =====================================>>  " + vendorAttachList);
        }

        model.addAttribute("appvPrcssStus", appvPrcssStus);
        model.addAttribute("appvPrcssResult", appvInfoAndItems.get(0).get("appvPrcssStus"));
        if(params.containsKey("costCenter")) {
            model.addAttribute("costCenterName", params.get("costCenterName").toString());
            model.addAttribute("costCenter", params.get("costCenter").toString());
        } else {
            model.addAttribute("costCenterName", vendorInfo.get("costCenterName").toString());
            model.addAttribute("costCenter", vendorInfo.get("costCenter").toString());
        }

        model.addAttribute("appvInfoAndItems", new Gson().toJson(appvInfoAndItems));
        model.addAttribute("vendorInfo", vendorInfo);
        model.addAttribute("bankList", bankList);
        model.addAttribute("countryList", countryList);
        model.addAttribute("viewType", params.get("viewType").toString());
        if(vendorInfo.containsKey("emroUpdName")){
        	String syncToEmroUsername = "By " + vendorInfo.get("emroUpdName").toString() + " [" +vendorInfo.get("emroUpdDate") + "]";
            model.addAttribute("updateUserName", syncToEmroUsername);
        }

        if(params.containsKey("appvPrcssNo")) {
            model.addAttribute("appvPrcssNo", params.get("appvPrcssNo"));
        }

        LOGGER.debug("vendorInfo =====================================>>  " + vendorInfo);

        return "eAccounting/vendor/vendorRequestViewPop";
    }

	@RequestMapping(value = "/saveEmroData.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> saveEmroData(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {

		int userId = sessionVO.getUserId();

		LOGGER.debug("saveEmroData =====================================>> " + params);

		vendorMgmtEmroService.saveEmroData(params, userId);

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);

	    return ResponseEntity.ok(message);
	  }

}
