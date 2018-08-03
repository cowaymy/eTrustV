package com.coway.trust.biz.logistics.agreement.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.agreement.agreementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("agreementService")

public class agreementServImpl extends EgovAbstractServiceImpl implements agreementService {

    @Resource(name = "agreementMapper")
    private agreementMapper agreementMapper;

    @Override
    public EgovMap getMemberInfo(Map<String, Object> params) {
        return agreementMapper.getMemberInfo(params);
    }

    @Override
    public EgovMap getMemHPpayment(Map<String, Object> params) {
        return agreementMapper.getMemHPpayment(params);
    }


    @Override
    public List<EgovMap> memberList(Map<String, Object> params) {
        return agreementMapper.memberList(params);
    }

    @Override
    public List<EgovMap> getMemStatus(Map<String, Object> params) {
        return agreementMapper.getMemStatus(params);
    }

    @Override
    public List<EgovMap> getMemLevel(Map<String, Object> params) {
        return agreementMapper.getMemLevel(params);
    }

    @Override
    public List<EgovMap> getAgreementVersion(Map<String, Object> params) {
        return agreementMapper.getAgreementVersion(params);
    }

    @Override
    public EgovMap getBranchCd(Map<String, Object> params) {
        return agreementMapper.getBranchCd(params);
    }

	@Override
	public List<EgovMap> branch() {
		return agreementMapper.branch();
	}

	@Override
    public EgovMap cdEagmt1(Map<String, Object> params) {
        return agreementMapper.cdEagmt1(params);
    }
}
