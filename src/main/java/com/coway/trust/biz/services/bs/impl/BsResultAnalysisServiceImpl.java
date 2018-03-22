package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.biz.services.bs.BsResultAnalysisService;
import com.coway.trust.biz.services.bs.impl.BsResultAnalysisMapper;

@Service("bsResultAnalysisService")
public class BsResultAnalysisServiceImpl extends EgovAbstractServiceImpl implements BsResultAnalysisService {

    private static final Logger logger = LoggerFactory.getLogger(BsResultAnalysisServiceImpl.class);

    @Resource(name="bsResultAnalysisMapper")
    private BsResultAnalysisMapper bsResultAnalysisMapper;

    @Autowired
    private MessageSourceAccessor messageSourceAccessor;

    @Override
    public EgovMap getUserInfo(Map<String, Object> params) {
        return bsResultAnalysisMapper.getUserInfo(params);
    }

    @Override
    public List<EgovMap> selectAnalysisList(Map<String, Object> params) {
        return bsResultAnalysisMapper.selectAnalysisList(params);
    }

    @Override
    public List<EgovMap> selResultAnalysisByMember(Map<String, Object> params) {
        return bsResultAnalysisMapper.selResultAnalysisByMember(params);
    }
}
