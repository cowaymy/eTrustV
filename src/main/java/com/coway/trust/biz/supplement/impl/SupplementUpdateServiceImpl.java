package com.coway.trust.biz.supplement.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
import com.coway.trust.biz.supplement.impl.SupplementUpdateMapper;
import com.coway.trust.biz.sales.pos.impl.PosServiceImpl;
import com.coway.trust.biz.sales.pos.impl.PosStockMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;




@Service("supplementUpdateService")
public class SupplementUpdateServiceImpl extends EgovAbstractServiceImpl implements SupplementUpdateService {

  private static final Logger LOGGER = LoggerFactory.getLogger(SupplementUpdateServiceImpl.class);

  @Resource(name = "posMapper")
  private PosMapper posMapper;

  @Resource(name = "posStockMapper")
  private PosStockMapper posStockMapper;

  @Resource(name = "supplementUpdateMapper")
  private SupplementUpdateMapper supplementUpdateMapper;

  @Override
  public List<EgovMap> selectPosJsonList(Map<String, Object> params) throws Exception {

    return supplementUpdateMapper.selectPosJsonList(params);
  }

  @Override
  public List<EgovMap> selectSupplementList(Map<String, Object> params) throws Exception {

    return supplementUpdateMapper.selectSupplementList(params);
  }

  @Override
  public List<EgovMap> selectSupRefStus() {

    return supplementUpdateMapper.selectSupRefStus();
  }

  @Override
  public List<EgovMap> selectSupRefStg() {

    return supplementUpdateMapper.selectSupRefStg();
  }

  @Override
  public List<EgovMap> selectSubmBrch() {

    return supplementUpdateMapper.selectSubmBrch();
  }

  public List<EgovMap> selectWhBrnchList() throws Exception {

	    return supplementUpdateMapper.selectWhBrnchList();
	  }

  @Override
  public List<EgovMap> getSupplementDetailList(Map<String, Object> params) throws Exception {

    return supplementUpdateMapper.getSupplementDetailList(params);
  }

  @Override
  public EgovMap selectOrderBasicInfo(Map<String, Object> params) throws Exception {

    return supplementUpdateMapper.selectOrderBasicInfo(params);
  }

  @Override
	public List<EgovMap> checkDuplicatedTrackNo(Map<String, Object> params) {

		return supplementUpdateMapper.checkDuplicatedTrackNo(params);
}

/*  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void updateRefStgStatus(Map<String, Object> transactionId){
	  supplementUpdateMapper.updateRefStgStatus(transactionId);
  }*/

  @Override
	public int updateRefStgStatus(Map<String, Object> params) {
      int result = supplementUpdateMapper.updateRefStgStatus(params);
		return result;
	}


}