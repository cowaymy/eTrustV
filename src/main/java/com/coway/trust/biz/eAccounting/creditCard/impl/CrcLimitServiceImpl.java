package com.coway.trust.biz.eAccounting.creditCard.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.coway.trust.biz.eAccounting.creditCard.CrcLimitService;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("crcLimitService")
public class CrcLimitServiceImpl implements CrcLimitService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CrcLimitServiceImpl.class);

    @Resource(name = "crcLimitMapper")
    private CrcLimitMapper crcLimitMapper;

    @Override
    public List<EgovMap> selectAllowanceCardList() {
        return crcLimitMapper.selectAllowanceCardList();
    }

    @Override
    public List<EgovMap> selectAllowanceCardPicList() {
        return crcLimitMapper.selectAllowanceCardPicList();
    }

    @Override
    public List<EgovMap> selectAllowanceList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {
        LOGGER.debug("========== selectAllowanceList ==========");
        LOGGER.debug("params :: {}", params);

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
        if(!"A1101".equals(costCentr) && sessionVO.getUserId() != 16178 && sessionVO.getUserId() != 22661)
            params.put("loginUserId", sessionVO.getUserId());

        String[] crcId = request.getParameterValues("crcDropdown");
        params.put("crcId", crcId);

        String[] crcPic = request.getParameterValues("crcPic");
        params.put("crcPic", crcPic);

        return crcLimitMapper.selectAllowanceList(params);
    }

    /*
     * Function applied at CreditCard group of programs
    @Override
    public EgovMap selectAvailableAllowanceAmt(Map<String, Object> params) throws Exception {
        return crcLimitMapper.selectAvailableAllowanceAmt(params);
    }
    */

    @Override
    public List<EgovMap> selectAttachList(String docNo) {
        return crcLimitMapper.selectAttachList(docNo);
    }

    @Override
    public List<EgovMap> selectAdjItems(Map<String, Object> params) {
        return crcLimitMapper.selectAdjItems(params);
    }

    @Override
    public EgovMap getCardInfo(Map<String, Object> params) {
        return crcLimitMapper.getCardInfo(params);
    }

    @Override
    public String saveRequest(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== saveRequest ==========");
        LOGGER.debug("params :: {}", params);

        String docNo = crcLimitMapper.getAdjDocNo();
        int sender = 0;
        int receiver = 0;
        int cnt = 0;

        if("1".equals((String) params.get("adjType")) || "2".equals((String) params.get("adjType"))) {
            // Transfer between Card Holder (1); Transfer between Period (2)
            Map<String, Object> insMap = new HashMap<String, Object>();
            String sAdjPeriod = "";
            String mth = "";
            String year = "";

            insMap.put("docNo", docNo);
            insMap.put("adjType", params.get("adjType"));
            insMap.put("amt", params.get("sAmt"));
            insMap.put("atchFileGrpId", params.get("atchFileGrpId"));
            insMap.put("adjRem", params.get("adjRem"));
            insMap.put("userId", sessionVO.getUserId());

            // Sender
            insMap.put("signal", "-");
            insMap.put("seq", 1);
            insMap.put("crcId", params.get("sCrcHolder"));

            sAdjPeriod = (String) params.get("sPeriod");
            mth = sAdjPeriod.substring(0, 2);
            year = sAdjPeriod.substring(3);

            insMap.put("month", mth);
            insMap.put("year", year);

            sender = crcLimitMapper.insertAdj_FCM33D(insMap);

            // Receiver
            insMap.put("signal", "+");
            insMap.put("seq", 2);
            insMap.put("crcId", params.get("rCrcHolder"));

            sAdjPeriod = (String) params.get("rPeriod");
            mth = sAdjPeriod.substring(0, 2);
            year = sAdjPeriod.substring(3);

            insMap.put("month", mth);
            insMap.put("year", year);

            receiver = crcLimitMapper.insertAdj_FCM33D(insMap);


        } else if("3".equals((String) params.get("adjType")) || "4".equals((String) params.get("adjType"))) {
            // Addition (3); Deduction (4)
            Map<String, Object> insMap = new HashMap<String, Object>();

            insMap.put("docNo", docNo);
            insMap.put("atchFileGrpId", params.get("atchFileGrpId"));
            insMap.put("amt", params.get("sAmt"));
            insMap.put("atchFileGrpId", params.get("atchFileGrpId"));
            insMap.put("adjRem", params.get("adjRem"));
            insMap.put("userId", sessionVO.getUserId());

            if("3".equals((String) params.get("adjType"))) {
                insMap.put("signal", "+");
                insMap.put("adjType", params.get("adjType"));
                insMap.put("amt", params.get("rAmt"));
                insMap.put("crcId", params.get("rCrcId_h"));

            } else if("4".equals((String) params.get("adjType"))) {
                insMap.put("signal", "-");
                insMap.put("adjType", params.get("adjType"));
                insMap.put("amt", params.get("sAmt"));
                insMap.put("crcId", params.get("sCrcId_h"));
            }

            String sAdjPeriod = ("3".equals((String) params.get("adjType"))) ? (String) params.get("rPeriod") : (String) params.get("sPeriod");
            int startAdjMth = Integer.parseInt(sAdjPeriod.substring(0, 2));
            int year = Integer.parseInt(sAdjPeriod.substring(3));
            insMap.put("year", year);

            // int seq = 1;

            insMap.put("seq", 1);
            insMap.put("month", startAdjMth);

            cnt = crcLimitMapper.insertAdj_FCM33D(insMap);

            /*
            for(int i = startAdjMth; i <= 12; i++) {
                insMap.put("seq", seq);
                insMap.put("month", startAdjMth);

                cnt = crcLimitMapper.insertAdj_FCM33D(insMap);

                seq++;
                cnt++;
            }
            */
        }

        if("1".equals((String) params.get("adjType")) || "2".equals((String) params.get("adjType"))) {
            if(sender <= 0 || receiver <= 0) {
                docNo = "";
            }
        } else {
            if(cnt <= 0) {
                docNo = "";
            }
        }

        return docNo;
    }

    @Override
    public List<EgovMap> selectAdjustmentList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {
        LOGGER.debug("========== selectAdjustmentList ==========");
        LOGGER.debug("params :: {}", params);

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
        if(!"A1101".equals(costCentr) && sessionVO.getUserId() != 16178 && sessionVO.getUserId() != 22661)
            params.put("loginUserId", sessionVO.getUserId());

        String[] adjType = request.getParameterValues("selAdjType");
        params.put("adjType", adjType);

        String[] crcId = request.getParameterValues("crcDropdown");
        params.put("crcId", crcId);

        String[] status = request.getParameterValues("status");
        params.put("status", status);

        return crcLimitMapper.selectAdjustmentList(params);
    }

    @Override
    public String editRequest(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== editRequest ==========");
        LOGGER.debug("params :: {}", params);

        String docNo = (String) params.get("adjNo");

        return docNo;
    }

    @Override
    public int submitAdjustment(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== submitAdjustment ==========");
        LOGGER.debug("params :: {}", params);

        params.put("userId", sessionVO.getUserId());

        int action = crcLimitMapper.insertApp_FCM34D(params);

        return action;
    }

    @Override
    public List<EgovMap> selectAdjustmentAppvList(Map<String, Object> params, HttpServletRequest request, SessionVO sessionVO) {
        LOGGER.debug("========== selectAdjustmentAppvList ==========");
        LOGGER.debug("params :: {}", params);

        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
        if(!"A1101".equals(costCentr)) params.put("loginUserId", sessionVO.getUserId());

        String[] adjType = request.getParameterValues("adjType");
        params.put("adjType", adjType);

        String[] crcId = request.getParameterValues("crcDropdown");
        params.put("crcId", crcId);

        return crcLimitMapper.selectAdjustmentAppvList(params);
    }

    @Override
    public int approvalUpdate(Map<String, Object> params, SessionVO sessionVO) {
        LOGGER.debug("========== approvalUpdate ==========");
        LOGGER.debug("params :: {}", params);

        int appCnt = 0;

        if(params.containsKey("grid")) {
            // Multiple
            List<Object> grid = (List<Object>) params.get("grid");
            for(int i = 0; i < grid.size(); i++) {
                Map<String, Object> gridItem = (Map<String, Object>) grid.get(i);

                Map<String, Object> appParam = new HashMap<String, Object>();
                appParam.put("adjNo", gridItem.get("adjNo"));
                appParam.put("action", params.get("action"));
                appParam.put("userId", sessionVO.getUserId());

                if("J".equals((String) params.get("action"))) {
                    appParam.put("rejctResn", params.get("rejctResn"));
                }

                appCnt += crcLimitMapper.updateApp_FCM34D(appParam);
            }
        } else {
            // Single
            params.put("userId", sessionVO.getUserId());
            appCnt += crcLimitMapper.updateApp_FCM34D(params);
        }

        return appCnt;
    }
}
