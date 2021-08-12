package com.coway.trust.biz.payment.payment.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.payment.payment.service.CommDeductionService;
import com.coway.trust.biz.payment.payment.service.PayDHistoryVO;
import com.coway.trust.biz.payment.payment.service.PayDVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;
import com.coway.trust.biz.payment.payment.service.SearchPaymentService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("commDeductionService")
public class CommDeductionServiceImpl extends EgovAbstractServiceImpl implements CommDeductionService {

	@Resource(name = "commDeductionMapper")
	private CommDeductionMapper commDeductionMapper;

	@Override
	public List<EgovMap> selectCommitionDeduction(Map<String, Object> params) {
		return commDeductionMapper.selectCommitionDeduction(params);
	}

	@Override
	public List<EgovMap> selectExistLogMList(Map<String, Object> params) {
		return commDeductionMapper.selectExistLogMList(params);
	}

  @Override
  @Transactional
  public int addBulkData(Map<String, Object> master, List<Map<String, Object>> detail) {

    List list = this.selectExistLogMList(master);
    int exist = 0;
    String refNo = String.valueOf(master.get("fileRefNo"));
    /*
     * if(list != null && list.size() > 0){ int fileSuffixCount = list.size() +
     * 1; master.put("fileRefNo", refNo + String.valueOf(fileSuffixCount));
     * }else{ master.put("fileRefNo", refNo + "1"); }
     */
    if (list.size() <= 0) {
      master.put("fileRefNo", refNo);

      this.insertMaster(master);

      for (int i = 0; i < detail.size(); i++) {
        detail.get(i).put("fileId", master.get("fileId"));
        detail.get(i).put("syncCompleted", false);
        this.insertDetail(detail.get(i));
      }
      exist = 1;
    }

    return exist;
  }

	@Override
	public void insertMaster(Map<String, Object> params) {
		commDeductionMapper.insertMaster(params);
	}

	@Override
	public void insertDetail(Map<String, Object> params) {
		commDeductionMapper.insertDetail(params);
	}

	@Override
	public List<EgovMap> selectMasterView(EgovMap params) {
		return commDeductionMapper.selectMasterView(params);
	}

	@Override
	public List<EgovMap> selectLogDetail(Map<String, Object> params) {
		return commDeductionMapper.selectLogDetail(params);
	}

	@Override
	public List<EgovMap> selectDetailForPaymentResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return commDeductionMapper.selectDetailForPaymentResult(params);
	}

	@Override
	public void createPaymentProcedure(EgovMap params) {
		commDeductionMapper.createPaymentProcedure(params);
	}

	@Override
    public void deactivateCommissionDeductionStatus(Map<String, Object> param){
	  commDeductionMapper.deactivateCommissionDeductionStatus(param);
    }

}
