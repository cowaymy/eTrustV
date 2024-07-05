package com.coway.trust.biz.supplement.payment.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.supplement.payment.service.SupplementAdvPaymentMatchService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("supplementAdvPaymentMatchService")
public class SupplementAdvPaymentMatchServiceImpl
  extends EgovAbstractServiceImpl
  implements SupplementAdvPaymentMatchService {
  @Resource(name = "supplementAdvPaymentMatchMapper")
  private SupplementAdvPaymentMatchMapper supplementAdvPaymentMatchMapper;

  private static final Logger LOGGER = LoggerFactory.getLogger( SupplementAdvPaymentMatchServiceImpl.class );

  @Override
  public List<EgovMap> selectAdvKeyInList( Map<String, Object> params ) {
    return supplementAdvPaymentMatchMapper.selectAdvKeyInList( params );
  }

  @Override
  public List<EgovMap> selectBankStateMatchList( Map<String, Object> params ) {
    return supplementAdvPaymentMatchMapper.selectBankStateMatchList( params );
  }

  @Override
  @Transactional
  public void saveAdvPaymentMapping( Map<String, Object> params ) {
    supplementAdvPaymentMatchMapper.mappingAdvGroupPayment( params );
    supplementAdvPaymentMatchMapper.mappingBankStatementAdv( params );
    List<EgovMap> returnList = supplementAdvPaymentMatchMapper.selectMappedData( params );

    if ( returnList != null && returnList.size() > 0 ) {
      for ( int i = 0; i < returnList.size(); i++ ) {
        EgovMap ifMap = (EgovMap) returnList.get( i );
        ifMap.put( "variance", params.get( "variance" ) );
        ifMap.put( "userId", params.get( "userId" ) );
        supplementAdvPaymentMatchMapper.insertAdvPaymentMatchIF( ifMap );
        supplementAdvPaymentMatchMapper.updateDiffTypeDiffAmt( ifMap );
      }
    }
  }

  @Transactional
  public void saveAdvPaymentDebtor( Map<String, Object> params ) {
    params.put( "remark", params.get( "debtorRemark" ) );
    supplementAdvPaymentMatchMapper.mappingAdvGroupPayment( params );
    List<EgovMap> returnList = supplementAdvPaymentMatchMapper.selectMappedData( params );

    if ( returnList != null && returnList.size() > 0 ) {
      for ( int i = 0; i < returnList.size(); i++ ) {
        EgovMap ifMap = (EgovMap) returnList.get( i );
        ifMap.put( "variance", params.get( "variance" ) );
        ifMap.put( "userId", params.get( "userId" ) );
        supplementAdvPaymentMatchMapper.insertAdvPaymentDebtorIF( ifMap );
      }
    }
  }

  @Override
  public List<EgovMap> getAccountList( Map<String, Object> params ) {
    return supplementAdvPaymentMatchMapper.getAccountList( params );
  }

  @Override
  public List<EgovMap> selectPaymentListByGroupSeq( Map<String, Object> params ) {
    return supplementAdvPaymentMatchMapper.selectPaymentListByGroupSeq( params );
  }

  @Override
  public List<EgovMap> selectAdvKeyInReport( Map<String, Object> params ) {
    return supplementAdvPaymentMatchMapper.selectAdvKeyInReport( params );
  }
}
