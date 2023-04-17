package com.coway.trust.web.eAccounting.expense;

import java.util.ArrayList;
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

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.eAccounting.expense.ExpenseService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/expense")
public class ExpenseController {


    private static final Logger LOGGER = LoggerFactory.getLogger(ExpenseController.class);

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @Resource(name = "expenseService")
    private ExpenseService expenseService;

    @RequestMapping(value = "/selectExpenseList.do")
    public String selectExpenseList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
        return "eAccounting/expense/expenseManagement";
    }

    @RequestMapping(value = "/selectExpenseList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectExpenseList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
        List<EgovMap> expenseList = null;

        String[] claimType = request.getParameterValues("claimType");
        //String[] expType = request.getParameterValues("expType");
        //String[] status = request.getParameterValues("status");

        params.put("claimType", claimType);
        //params.put("expType", expType);
        //params.put("status", status);

//        if(CommonUtils.isEmpty(params.get("type"))){
//            params.put("expType", expType);
//        }

        LOGGER.debug("groupCd =====================================>>  " + params);

        expenseList = expenseService.selectExpenseList(params);

        return ResponseEntity.ok(expenseList);
    }

    @RequestMapping(value = "/addExpenseTypePop.do")
    public String addExpenseTypePop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
        LOGGER.debug("Params =====================================>>  " + params);

        return "eAccounting/expense/addExpenseTypePop";
    }

    @RequestMapping(value = "/budgetCodeSearchPop.do")
    public String budgetCodeSearchPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
        model.addAttribute("pop", params.get("pop"));
        model.addAttribute("call", params.get("call"));
        model.addAttribute("resultList", params);
        LOGGER.debug("Params >>> " + params);
        return "eAccounting/expense/budgetCodeSearchPop";
    }

    @RequestMapping(value = "/expenseCode.do")
    public String expenseCodeList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
        model.addAttribute("pop", params.get("pop"));
        model.addAttribute("call", params.get("call"));
        return "eAccounting/expense/expenseCodeSearchPop";
    }

    @RequestMapping(value = "/glAccountSearchPop.do")
    public String glAccountSearchPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
        model.addAttribute("pop", params.get("pop"));
        model.addAttribute("call", params.get("call"));
        model.addAttribute("resultList", params);
        return "eAccounting/expense/glAccountSearchPop";
    }

    @RequestMapping(value = "/expenseTypeSearchPop.do")
    public String expenseTypeSearchPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
        model.addAttribute("popClaimType", params.get("popClaimType").toString());
        return "eAccounting/expense/expenseTypeSearchPop";
    }

    @RequestMapping(value = "/editExpenseTypePop.do")
    public String editExpenseTypePop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
        LOGGER.debug("params =====================================>>  " + params);

        model.addAttribute("popClaimType", params.get("popClaimType").toString());
        model.addAttribute("popExpType", params.get("popExpType").toString());
        model.addAttribute("glAccCode", params.get("popGlAccCode").toString());
        model.addAttribute("glAccCodeName", params.get("popGlAccCodeName").toString());
        model.addAttribute("budgetCode", params.get("popBudgetCode").toString());
        model.addAttribute("budgetCodeName", params.get("popBudgetCodeName").toString());
        model.addAttribute("taxCode", params.get("popTaxCode").toString());
        model.addAttribute("cntrlCheck", params.get("popCntrlCheck").toString());
        model.addAttribute("disabFlag", params.get("popDisablFlag").toString());

        return "eAccounting/expense/editExpenseTypePop";
    }

    @RequestMapping(value = "/insertExpenseInfo", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> insertExpenseInfo (@RequestBody Map<String, ArrayList<Object>> params, ModelMap model,    SessionVO sessionVO) throws Exception{
        LOGGER.debug("params =====================================>>  " + params);

        List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList

        int tmpCnt = 0;
        int totCnt = 0;

        if (addList.size() > 0) {
            tmpCnt = expenseService.insertExpenseInfo(addList, sessionVO.getUserId());
            totCnt = totCnt + tmpCnt;
        }

        // 결과 만들기 예.
        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(totCnt);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/selectBudgetCodeList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectBudgetCodeList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
        LOGGER.debug("Params =====================================>>  " + params);

        List<EgovMap> budgetCodeList = null;
        budgetCodeList = expenseService.selectBudgetCodeList(params);

        return ResponseEntity.ok(budgetCodeList);
    }

    @RequestMapping(value = "/selectCodeListBG", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectCodeListBG (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
        LOGGER.debug("Params =====================================>>  " + params);

        List<EgovMap> budgetCodeList = null;
        budgetCodeList = expenseService.selectCodeListWO(params);

        return ResponseEntity.ok(budgetCodeList);
    }

    @RequestMapping(value = "/selectExpenseCodeList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectExpenseCodeList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
        LOGGER.debug("Params =====================================>>  " + params);

        List<EgovMap> expenseCodeList = null;
        expenseCodeList = expenseService.selectExpenseCodeList(params);

        return ResponseEntity.ok(expenseCodeList);
    }

    @RequestMapping(value = "/selectGlCodeList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectGlCodeList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
        LOGGER.debug("Params =====================================>>  " + params);

        List<EgovMap> glCodeList = null;
        glCodeList = expenseService.selectGlCodeList(params);

        return ResponseEntity.ok(glCodeList);
    }

    @RequestMapping(value = "/updateExpenseInfo", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateExpenseInfo (@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
        LOGGER.debug("params =====================================>>  " + params);

        params.put("userId", sessionVO.getUserId());
        params.put("clmType", params.get("pClmType"));
        params.put("expType", params.get("pExpType"));

        int totCnt = expenseService.updateExpenseInfo(params);

        // 결과 만들기 예.
        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(totCnt);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);

    }

    @RequestMapping(value = "/selectCodeList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) throws Exception {
        LOGGER.debug("groupCode : {}", params);

        List<EgovMap> codeList = expenseService.selectCodeList(params);
        return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/selectExpenseListMain", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectExpenseListMain (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
        List<EgovMap> expenseList = null;

        String[] claimType = request.getParameterValues("claimType");
        params.put("claimType", claimType);

        LOGGER.debug("groupCd =====================================>>  " + params);

        expenseList = expenseService.selectExpenseListMain(params);

        return ResponseEntity.ok(expenseList);
    }
}

