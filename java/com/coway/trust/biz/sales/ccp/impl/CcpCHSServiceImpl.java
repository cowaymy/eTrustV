package com.coway.trust.biz.sales.ccp.impl;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ccp.CcpCHSService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.web.sales.ccp.CHSRawDataVO;
import com.coway.trust.web.sales.SalesConstants;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpCHSService")
public class CcpCHSServiceImpl extends EgovAbstractServiceImpl implements CcpCHSService {

    private static final Logger logger = LoggerFactory.getLogger(CcpCHSServiceImpl.class);

    @Resource(name = "ccpCHSMapper")
    private CcpCHSMapper ccpCHSMapper;

    @Autowired
    private AdaptorService adaptorService;


    @Override
    public int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {
        // TODO Auto-generated method stub
        int mastetSeq = ccpCHSMapper.selectNextBatchId();
        master.put("chsBatchId", mastetSeq);
        int mResult = ccpCHSMapper.insertCustHealthScoreMst(master); // INSERT INTO SAL0263D

        int size = 1000;
        int page = detailList.size() / size;
        int start;
        int end;

        Map<String, Object> chslist = new HashMap<>();
        chslist.put("chsBatchId", mastetSeq);
        for (int i = 0; i <= page; i++) {
            start = i * size;
            end = size;

            if(i == page){
                end = detailList.size();
            }

            chslist.put("list",
                detailList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
            ccpCHSMapper.insertCustHealthScoreDtl(chslist); // INSERT INTO SAL0264D
        }

        //CALL PROCEDURE
        ccpCHSMapper.callBatchCHSUpdScore(master); // MERGE INTO SAL0262D


        return mastetSeq;
    }


    @Override
    public List<EgovMap> selectCcpCHSMstList(Map<String, Object> params) {
        // TODO Auto-generated method stub
        return ccpCHSMapper.selectCcpCHSMstList(params);
    }

    @Override
    public EgovMap selectCHSInfo(Map<String, Object> params) {
        // TODO Auto-generated method stub
      EgovMap chsBatchInfo = ccpCHSMapper.selectCHSMasterInfo(params);
      List<EgovMap> chsBatchDtlInfo = ccpCHSMapper.selectCHSDetailInfo(params);

        chsBatchInfo.put("chsBatchItem", chsBatchDtlInfo);
        return chsBatchInfo;
    }
}
