package com.coway.trust.biz.sales.eSVM.impl;

import java.math.MathContext;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import org.joda.time.LocalDate;
import org.joda.time.Months;
import java.time.Period;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiDto;
import com.coway.trust.api.mobile.sales.eSVM.eSVMApiForm;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.sales.eSVM.eSVMApiService;
import com.coway.trust.biz.sales.eSVM.impl.eSVMApiMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.math.BigDecimal;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import com.coway.trust.biz.common.CommonService;

@Service("eSVMApiService")
public class eSVMApiServiceImpl
  extends EgovAbstractServiceImpl
  implements eSVMApiService {
  private static final Logger logger = LoggerFactory.getLogger( eSVMApiServiceImpl.class );

  @Resource(name = "eSVMApiMapper")
  private eSVMApiMapper eSVMApiMapper;

  @Resource(name = "commonService")
  private CommonService commonService;

  @Autowired
  private LoginMapper loginMapper;

  @Autowired
  private AdaptorService adaptorService;

  @Override
  public List<EgovMap> selectQuotationList( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getReqstDtFrom() ) || CommonUtils.isEmpty( param.getReqstDtTo() ) ) {
      throw new ApplicationException( AppConstants.FAIL, " Request Date  does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getSelectType() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "Select Type value does not exist." );
    }
    else {
      if ( ( "2" ).equals( param.getSelectType() ) && param.getSelectKeyword().length() < 5 ) {
        throw new ApplicationException( AppConstants.FAIL, "Please enter at least 5 characters." );
      }
    }
    if ( CommonUtils.isEmpty( param.getRegId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "User ID value does not exist." );
    }
    return eSVMApiMapper.selectQuotationList( eSVMApiForm.createMap( param ) );
  }

  @Override
  public eSVMApiDto selectSvmOrdNo( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    // membershipController.selectMembershipFreeConF
    EgovMap svmOrdDet = eSVMApiMapper.selectSvmOrdNo( eSVMApiForm.createMap( param ) );
    eSVMApiDto rtn = new eSVMApiDto();
    EgovMap ordMemInfo = eSVMApiMapper.selectOrderMemInfo( eSVMApiForm.createMap( param ) ); // fn_getDataInfo
    if ( svmOrdDet == null || svmOrdDet.isEmpty() ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "No order found or this order is not under complete status or activation status" );
    }
    else if ( ordMemInfo == null ) {
      int errorCode = 0;
      String errorHeader = null;
      String errorMsg = null;
      errorCode = 99;
      errorHeader = "Warning";
      errorMsg = "This order is not valid for membership";
      rtn.setErrorCode( errorCode );
      rtn.setErrorHeader( errorHeader );
      rtn.setErrorMsg( errorMsg );
    }
    else {
      // fn_getDataInfo
      rtn = eSVMApiDto.create( eSVMApiMapper.selectOrderMemInfo( eSVMApiForm.createMap( param ) ) );
      // [Membership Tab]
      if ( "NEW".equals( param.getMode() ) ) {
        if ( param.getUserNm() == null ) {
          throw new ApplicationException( AppConstants.FAIL, "Member code is not found. Please Contact IT." );
        }
        if ( ( param.getUserNm().toUpperCase().equals( "100116" )
          || param.getUserNm().toUpperCase().equals( "100224" ) ) ) {
          //Special Bypass for Marketing requirement
        }
        else {
          if ( rtn.getCustCntId() == 964 ) {
            //Only Individual Customer Order for check
            //Check Configuration CD
            //Get membership expiry month if any
            Map<String, Object> configParam = new HashMap<String, Object>();
            configParam.put( "module", "SALES" );
            configParam.put( "subModule", "MEMBERSHIP" );
            configParam.put( "paramCode", "MEM_TYPE" );
            List<EgovMap> memType = eSVMApiMapper.selectSystemConfigurationParamVal( configParam );
            if ( !memType.isEmpty() ) {
              configParam.put( "memType", memType );
            }
            configParam.put( "salesOrdId", rtn.getSalesOrdId() );
            configParam.put( "memCode", param.getUserNm() );
            EgovMap serviceExpiry = eSVMApiMapper.selectSvcExpire( configParam );
            if ( serviceExpiry == null ) {
              EgovMap salesPerson = eSVMApiMapper.selectSalesPerson( configParam );
              if ( salesPerson == null ) {
                throw new ApplicationException( AppConstants.FAIL, "Your input member code : " + param.getUserNm()
                  + " is not allowed for membership creation." );
              }
            }
            else {
              int monthExpired = Integer.parseInt( serviceExpiry.get( "monthExpired" ).toString() );
              if ( monthExpired < 2 ) {
                EgovMap salesConfigPerson = eSVMApiMapper.selectConfigurationSalesPerson( configParam );
                if ( salesConfigPerson == null ) {
                  throw new ApplicationException( AppConstants.FAIL, "Your input member code : " + param.getUserNm()
                    + " is not allowed for membership creation." );
                }
              }
              else {
                EgovMap salesPerson = eSVMApiMapper.selectSalesPerson( configParam );
                if ( salesPerson == null ) {
                  throw new ApplicationException( AppConstants.FAIL, "Your input member code : " + param.getUserNm()
                    + " is not allowed for membership creation." );
                }
              }
            }
            //Check Configuration CD End
          }
        }
        // Mode :: New
        int stkId = Integer.parseInt( svmOrdDet.get( "stkId" ).toString() );
        int[] discontinueStk = { 1, 651, 218, 689, 216, 687, 3, 653 };
        List<Object> discontinueList = new ArrayList<Object>();
        for ( int i = 0; i < discontinueStk.length; i++ ) {
          discontinueList.add( discontinueStk[i] );
        }
        if ( discontinueList.indexOf( stkId ) >= 0 ) {
          throw new ApplicationException( AppConstants.FAIL,
                                          "Product have been discontinued. Therefore, create new quotation is not allowed" );
        }
        // fn_isActiveMembershipQuotationInfoByOrderNo
        // membershipQuotationController.mActiveQuoOrder
        EgovMap hasActiveQuot = eSVMApiMapper.checkActiveQuot( eSVMApiForm.createMap( param ) );
        if ( Integer.parseInt( hasActiveQuot.get( "cnt" ).toString() ) > 0 ) {
          throw new ApplicationException( AppConstants.FAIL, "This order already has "
            + hasActiveQuot.get( "cnt" ).toString() + " active quotation. New quotation not allowed." );
        }
        EgovMap hasActiveEsvm = eSVMApiMapper.checkActiveESvm( eSVMApiForm.createMap( param ) );
        if ( Integer.parseInt( hasActiveEsvm.get( "cnt" ).toString() ) > 0 ) {
          throw new ApplicationException( AppConstants.FAIL, "This order already has "
            + hasActiveEsvm.get( "cnt" ).toString() + " active record in eSVM. New quotation not allowed." );
        }
        // getMaxPeriodEarlyBirdPromo
        if ( rtn.getMemExprDate() != null ) { // CELESTE
          String memExprDate = rtn.getMemExprDate();
          logger.debug( "rtn :: " + rtn.toString() );
          logger.debug( " rtn.getMemExprDate() :: " + rtn.getMemExprDate() );
          logger.debug( "memExprDate :: " + memExprDate );
          Map<String, Object> map = new HashMap<String, Object>();
          map.put( "memExprDt", memExprDate.substring( 6 ) + memExprDate.substring( 3, 5 ) );
          rtn.setStrprmodt( eSVMApiMapper.getMaxPeriodEarlyBirdPromo( map ) );
        }
        param.setSalesOrdId( rtn.getSalesOrdId() );
        // membershipQuotationController.getOrderCurrentBillMonth
        // Use billMonth to query for outstanding
        Map<String, Object> billParam = new HashMap<String, Object>();
        billParam.put( "salesOrdId", rtn.getSalesOrdId() );
        billParam.put( "appTypeId", rtn.getAppTypeId() );
        billParam.put( "rentalStus", rtn.getRentalStus() );
        String checkRentalBillMonth = this.checkRentalBillMonth( billParam );
        logger.debug( " >>>>>>>>>>>>>>>>>>>>>>>>>>> :: " + checkRentalBillMonth );
        if ( !checkRentalBillMonth.isEmpty() ) {
          throw new ApplicationException( AppConstants.FAIL,
                                          "Order has outstanding, membership purchase not allowed." );
        }
        // Set hiddenHasFilterCharge from ProductFilterList
        param.setFlag( "Y" );
        // List<EgovMap> selectProductFilterList = eSVMApiMapper.selectProductFilterList(eSVMApiForm.createMap(param)); // 20211027
        List<EgovMap> selectProductFilterList = new ArrayList<EgovMap>();
        selectProductFilterList = eSVMApiMapper.selectProductFilterList( eSVMApiForm.createMap( param ) );
        String hiddenHasFilterCharge = "";
        // if(selectProductFilterList.size() > 0) { // 20211027
        if ( !selectProductFilterList.isEmpty() ) {
          Map<String, String> listItem = selectProductFilterList.get( 0 );
          Iterator<Entry<String, String>> it = listItem.entrySet().iterator();
          while ( it.hasNext() ) {
            Map.Entry pair = (Map.Entry) it.next();
            hiddenHasFilterCharge = pair.getValue().toString();
          }
        }
        logger.debug( "hiddenHasFilterCharge.HiddenHasFilterCharge :: " + hiddenHasFilterCharge );
        if ( hiddenHasFilterCharge != "" ) {
          rtn.setHiddenHasFilterCharge( Integer.parseInt( hiddenHasFilterCharge ) );
        }
        // Type of Package
        List<EgovMap> selectComboPackageList = eSVMApiMapper.selectComboPackageList( eSVMApiForm.createMap( param ) );
        List<eSVMApiDto> comboPackageList = selectComboPackageList.stream().map( r -> eSVMApiDto.create( r ) )
                                                                  .collect( Collectors.toList() );
        rtn.setPackageComboList( comboPackageList );
        // Package Promotion
        List<EgovMap> selectPackagePromoList = eSVMApiMapper.selectPackagePromo( eSVMApiForm.createMap( param ) );
        List<eSVMApiDto> packagePromoList = selectPackagePromoList.stream().map( r -> eSVMApiDto.create( r ) )
                                                                  .collect( Collectors.toList() );
        rtn.setPackagePromoList( packagePromoList );
        // Filter Promotion
        List<EgovMap> selectFilterPromoList = eSVMApiMapper.selectFilterPromo( eSVMApiForm.createMap( param ) );
        List<eSVMApiDto> filterPromoList = selectFilterPromoList.stream().map( r -> eSVMApiDto.create( r ) )
                                                                .collect( Collectors.toList() );
        rtn.setFilterPromoList( filterPromoList );
      }
      else {
        // Mode :: Detail
        // Get SMQ details (SAL0093D)
        logger.debug( "selectSvmOrdNo :: svmQuotId :: " + String.valueOf( param.getSvmQuotId() ) );
        EgovMap smqDet = new EgovMap();
        smqDet = eSVMApiMapper.selectSmqDetail( eSVMApiForm.createMap( param ) );
        rtn.setSrvMemPacId( Integer.parseInt( smqDet.get( "srvMemPacId" ).toString() ) );
        rtn.setSrvDur( Integer.parseInt( smqDet.get( "srvDur" ).toString() ) );
        rtn.setEmpChk( smqDet.get( "empChk" ).toString() );
        // rtn.setSrvPacPromoId(smqDet.get("srvPacPromoId"));
        // rtn.setSrvPromoId(smqDet.get("srvPromoId"));
        rtn.setSrvMemPacAmt( Double.parseDouble( smqDet.get( "srvMemPacAmt" ).toString() ) );
        rtn.setPackageTaxPrice( Double.parseDouble( smqDet.get( "srvMemPacTxs" ).toString() ) );
        rtn.setSrvMemPacNetAmt( Double.parseDouble( smqDet.get( "srvMemPacNetAmt" ).toString() ) );
        rtn.setPaymentAmt( Double.parseDouble ( smqDet.get( "paymentAmt" ).toString() ) );
        rtn.setSrvMemBsAmt( Integer.parseInt( smqDet.get( "srvMemBsAmt" ).toString() ) );

        rtn.setTaxRate( CommonUtils.nvl( commonService.getSstTaxRate() ) );
        // Get SMQ Filter details (SAL0094D)
        // EgovMap smqFilterDet = new EgovMap();
        // smqFilterDet = eSVMApiMapper.selectSmqFilterDetail(eSVMApiForm.createMap(param));
        // rtn.setSmqFilterList
        // Get Type of Package description
        rtn.setPackageDesc( eSVMApiMapper.selectPackageDesc( smqDet ) ); // packageDesc
        // Get Package Information description
        rtn.setPackageInfoDesc( eSVMApiMapper.selectPackageInfoDesc( smqDet ) ); // packageInfoDesc
        // Get Filter Promotion description
        rtn.setFilterPromoDesc( eSVMApiMapper.selectFilterPromoDesc( smqDet ) ); // filterPromoDesc
        List<EgovMap> selectSVMFilterList = eSVMApiMapper.selectSvmFilter( eSVMApiForm.createMap( param ) );
        List<eSVMApiDto> svmFilterList = selectSVMFilterList.stream().map( r -> eSVMApiDto.create( r ) )
                                                            .collect( Collectors.toList() );
        rtn.setSvmFilterList( svmFilterList );
      }
    }
    return rtn;
  }

  @Override
  public List<EgovMap> selectProductFilterList( eSVMApiForm param )
    throws Exception {
    logger.info( "===== selectProductFilterList =====" );
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    return eSVMApiMapper.selectProductFilterList( eSVMApiForm.createMap( param ) );
  }

  @Override
  public eSVMApiDto selectOrderMemInfo( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getSalesOrdId() ) || param.getSalesOrdId() <= 0 ) {
      throw new ApplicationException( AppConstants.FAIL, "Sales order ID value does not exist." );
    }
    eSVMApiDto selectOrderMemDetail = eSVMApiDto.create( eSVMApiMapper.selectOrderMemInfo( eSVMApiForm.createMap( param ) ) );
    return selectOrderMemDetail;
  }

  @Override
  public eSVMApiDto selectPackageFilter( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    eSVMApiDto rtn = new eSVMApiDto();
    // Package Promotion
    List<EgovMap> selectPackagePromoList = eSVMApiMapper.selectPackagePromo( eSVMApiForm.createMap( param ) );
    List<eSVMApiDto> packagePromoList = selectPackagePromoList.stream().map( r -> eSVMApiDto.create( r ) )
                                                              .collect( Collectors.toList() );
    rtn.setPackagePromoList( packagePromoList );
    // Filter Promotion
    List<EgovMap> selectFilterPromoList = eSVMApiMapper.selectFilterPromo( eSVMApiForm.createMap( param ) );
    List<eSVMApiDto> filterPromoList = selectFilterPromoList.stream().map( r -> eSVMApiDto.create( r ) )
                                                            .collect( Collectors.toList() );
    rtn.setFilterPromoList( filterPromoList );
    // Get default package info
    // mNewQuotationPop.jsp :: fn_getMembershipPackageInfo(_id)
    String zeroRatYn = "Y";
    String eurCertYn = "Y";
    int zeroRat = eSVMApiMapper.selectGSTZeroRateLocation( eSVMApiForm.createMap( param ) );
    if ( zeroRat > 0 )
      zeroRatYn = "N";
    param.setZeroRatYn( zeroRatYn );
    int eurCert = eSVMApiMapper.selectGSTEURCertificate( eSVMApiForm.createMap( param ) );
    if ( eurCert > 0 )
      eurCertYn = "N";
    param.setEurCertYn( eurCertYn );
    EgovMap packageInfo = eSVMApiMapper.mPackageInfo( eSVMApiForm.createMap( param ) );
    logger.debug( "srvMemPacId :: " + packageInfo.get( "srvMemPacId" ).toString() );
    if ( CommonUtils.isEmpty( packageInfo.get( "srvMemPacId" ) ) ) {
      rtn.setHiddenHasPackage( 0 );
      rtn.setBsFreq( "" );
      rtn.setPackagePrice( 0 );
      rtn.setHiddenNormalPrice( 0 );
    }
    else {
      logger.debug( "srvMemItmPrc :: " + packageInfo.get( "srvMemItmPrc" ).toString() );
      int year = param.getSubYear() / 12;
      int pkgPrice = Math.round( Integer.parseInt( packageInfo.get( "srvMemItmPrc" ).toString() ) * year );
      //int pkgTaxPrice = Math.round( Integer.parseInt( packageInfo.get( "srvMemItmLbrAmt" ).toString() ) * year );
      rtn.setZeroRatYn( zeroRatYn );
      rtn.setEurCertYn( eurCertYn );
      rtn.setHiddenHasPackage( 1 );
      rtn.setBsFreq( packageInfo.get( "srvMemItmPriod" ).toString() + " month(s)" );
      rtn.setHiddenBsFreq( packageInfo.get( "srvMemItmPriod" ).toString() );
      rtn.setHiddenNormalPrice( pkgPrice );
      //rtn.setHiddenNormalTaxPrice( pkgTaxPrice );
      rtn.setSrvMemPacId( Integer.parseInt( packageInfo.get( "srvMemPacId" ).toString() ) );
      if ( "N".equals( eurCertYn ) ) {
        rtn.setPackagePrice( (int) Math.floor( pkgPrice ) );
        rtn.setHiddenNormalPrice( (int) Math.floor( pkgPrice ) );
        //rtn.setPackageTaxPrice( (int) Math.floor( pkgTaxPrice ) );
        //rtn.setHiddenNormalTaxPrice( (int) Math.floor( pkgTaxPrice ) );
      }
      else {
        rtn.setPackagePrice( pkgPrice );
        rtn.setHiddenNormalPrice( pkgPrice );
        //rtn.setPackageTaxPrice( pkgTaxPrice );
        //rtn.setHiddenNormalTaxPrice( pkgTaxPrice );
      }
      // mNewQuotationPop.jsp :: fn_setDefaultFilterPromo
      // mNewQuotationPop.jsp :: fn_getFilterChargeList
      if ( !"0".equals( param.getHiddenIsCharge().toString() ) ) {
        if ( param.getEmployee() == "1" ) {
          param.setGroupCode( "466" );
          param.setCodeName( "FIL_MEM_DEFAULT_PROMO_EMP" );
        }
        else {
          param.setGroupCode( "466" );
          param.setCodeName( "FIL_MEM_DEFAULT_PROMO_N_EMP" );
        }
        int promoId = eSVMApiMapper.getDfltPromo( eSVMApiForm.createMap( param ) );
        logger.debug( "promoId :: " + Integer.toString( promoId ) );
        param.setPromoId( promoId );
        rtn.setFilterPromoId( promoId );
        logger.debug( "========== getFilterChargeList_m ==========" );
        logger.debug( "param : {}", eSVMApiForm.createMap( param ) );
        rtn.setFilterCharge( this.getFilterChargeList_m( eSVMApiForm.createMap( param ) ) );
      }

      String taxRate = CommonUtils.nvl( commonService.getSstTaxRate() );
      rtn.setTaxRate( taxRate );
    }
    return rtn;
  }

  private int getFilterChargeList_m( Map<String, Object> param ) {
    // mNewQuotationPop.jsp :: fn_getFilterChargeList
    // MembershipQuotationServiceImpl.getFilterChargeListSum
    int filterChargeSum = 0;
    eSVMApiMapper.getSVMFilterCharge( param );
    List<EgovMap> list = (List<EgovMap>) param.get( "p1" );
    for ( EgovMap result : list ) {
      double prc = Math.floor( Double.parseDouble( result.get( "prc" ).toString() ) );
      if ( "N".equals( param.get( "zeroRatYn" ) ) || "N".equals( param.get( "eurCertYn" ) ) ) {
        filterChargeSum += Math.floor( (double) ( prc ) );
      }
      else {
        filterChargeSum += prc;
      }
    }
    return filterChargeSum;
  }

  @Override
  public eSVMApiDto getPromoDisc( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    return eSVMApiDto.create( eSVMApiMapper.getPromoDisc( eSVMApiForm.createMap( param ) ) );
  }

  @Override
  public eSVMApiDto getFilterChargeSum( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    eSVMApiDto rtn = new eSVMApiDto();
    rtn.setFilterCharge( this.getFilterChargeList_m( eSVMApiForm.createMap( param ) ) );
    return rtn;
  }

  @Override
  public List<EgovMap> selectFilterList( eSVMApiForm param )
    throws Exception {
    Map<String, Object> map = eSVMApiForm.createMap( param );
    eSVMApiMapper.getSVMFilterCharge( map );
    List<EgovMap> list = (List<EgovMap>) map.get( "p1" );
    return list;
  }

  @Override
  public eSVMApiDto getOrderCurrentBillMonth( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    eSVMApiDto rtn = new eSVMApiDto();
    String msg = this.checkRentalBillMonth( eSVMApiForm.createMap( param ) );
    logger.debug( "getOrderCurrentBillMonth :: msg :: " + msg );
    rtn.setMsg( msg );
    return rtn;
  }

  private String checkRentalBillMonth( Map<String, Object> params ) {
    logger.debug( "checkRentalBillMonth :: params :: {}", params );
    int billMonth = 0;
    String msg = "";
    EgovMap billMonthMap = new EgovMap();
    billMonthMap = eSVMApiMapper.getOrderCurrentBillMonth( params );
    // boolean billMonthBool = billMonthMap.isEmpty();
    // logger.debug("billMonthBool :: " + String.valueOf(billMonthBool));
    logger.debug( "billMonthBool :: " + billMonthMap == null ? "null" : "not null" );
    if ( billMonthMap != null ) {
      if ( Integer.parseInt( billMonthMap.get( "nowDate" )
                                         .toString() ) > Integer.parseInt( billMonthMap.get( "rentInstDt" )
                                                                                       .toString() ) ) {
        billMonth = 61;
      }
      else {
        params.put( "RENT_INST_DT", "SYSDATE" );
        EgovMap billMonthMap_1 = new EgovMap();
        billMonthMap_1 = eSVMApiMapper.getOrderCurrentBillMonth( params );
        // if(billMonthMap_1.size() > 0) {
        if ( billMonthMap_1 != null ) {
          billMonth = Integer.parseInt( billMonthMap.get( "rentInstNo" ).toString() );
        }
      }
    }
    // fn_checkRentalOrder(BillMonth)
    if ( "66".equals( params.get( "appTypeId" ).toString() ) ) {
      if ( "REG".equals( params.get( "rentalStus" ).toString() )
        || "INV".equals( params.get( "rentalStus" ).toString() ) ) {
        if ( billMonth > 60 ) {
          eSVMApiMapper.getOrdOtstnd( params );
          EgovMap map = (EgovMap) ( (ArrayList) params.get( "p1" ) ).get( 0 );
          if ( Double.parseDouble( map.get( "ordTotOtstnd" ).toString().replace( ",", "" ) ) > 0 ) {
            msg = "hasOtstnd";
          }
          else {
            EgovMap outrightMemLedge = eSVMApiMapper.getOutrightMemLedge( params );
            if ( !outrightMemLedge.isEmpty() ) {
              if ( Double.parseDouble( outrightMemLedge.get( "amt" ).toString().replace( ",", "" ) ) > 0 ) {
                msg = "hasOtstnd";
              }
            }
          }
        }
      }
    }
    else {
      EgovMap outrightMemLedge = eSVMApiMapper.getOutrightMemLedge( params );
      if ( !outrightMemLedge.isEmpty() ) {
        if ( Double.parseDouble( outrightMemLedge.get( "amt" ).toString().replace( ",", "" ) ) > 0 ) {
          msg = "hasOtstnd";
        }
      }
    }
    return msg;
  }

  @Override
  public eSVMApiDto saveQuotationReq( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    logger.debug( "param :: {}" + param );
    EgovMap hasActiveQuot = eSVMApiMapper.checkActiveQuot( eSVMApiForm.createMap( param ) );
    if ( Integer.parseInt( hasActiveQuot.get( "cnt" ).toString() ) > 0 ) {
      throw new ApplicationException( AppConstants.FAIL, "This order already has "
        + hasActiveQuot.get( "cnt" ).toString() + " active quotation. New quotation not allowed." );
    }
    eSVMApiDto rtn = new eSVMApiDto();
    Map<String, Object> preInsMap = new HashMap<String, Object>();
    // Membership checking for Package ID = 9 when itemSrvMemExprDt = null
    /*
     * if(param.getSvmAllowFlg() == false && param.getSrvMemPacId().equals("9")) { throw new
     * ApplicationException(AppConstants.FAIL, "The order is too early to subscribe for SVM."); }
     */
    // MembershipQuotationServiceImpl.insertQuotationInfo
    boolean boolEurCert = "Y".equals( param.getEurCertYn() ) ? true : false;
    boolean boolZeroRat = "Y".equals( param.getZeroRatYn() ) ? true : false;
    // if ( !boolEurCert ) {
    //if ( !boolEurCert || !boolZeroRat ) {
    //  param.setSrvMemPacTaxes( "0" );
    //}
    //else {
      //double srvMemPacAmt = 0;
      //double srvMemPacNetAmt = 0;
      //double cvtMemPacNetAmt = 0;

      BigDecimal srvMemPacAmt = BigDecimal.ZERO;
      BigDecimal srvMemPacNetAmt = BigDecimal.ZERO;
      BigDecimal cvtMemPacNetAmt = BigDecimal.ZERO;

      srvMemPacAmt = CommonUtils.nvl( param.getSrvMemPacAmt() ) != "" ? new BigDecimal (param.getSrvMemPacAmt()) : BigDecimal.ZERO;
      srvMemPacNetAmt = CommonUtils.nvl( param.getSrvMemPacNetAmt() ) != "" ? new BigDecimal (param.getSrvMemPacNetAmt()) : BigDecimal.ZERO;
      srvMemPacNetAmt = srvMemPacNetAmt.multiply( new BigDecimal("100") );
      cvtMemPacNetAmt = srvMemPacNetAmt.setScale( 2 );
      srvMemPacNetAmt = cvtMemPacNetAmt.divide( new BigDecimal("100") );

      // srvMemPacAmt = CommonUtils.intNvl( param.getSrvMemPacAmt() );
      // srvMemPacNetAmt = CommonUtils.intNvl( param.getSrvMemPacNetAmt() );
      // srvMemPacNetAmt = srvMemPacAmt * 100;
      // cvtMemPacNetAmt = Math.round( srvMemPacNetAmt );
      // srvMemPacNetAmt = cvtMemPacNetAmt / 100;
      param.setSrvMemPacNetAmt( String.valueOf( srvMemPacNetAmt ) );
      param.setSrvMemPacTaxes( String.valueOf( srvMemPacAmt.subtract(srvMemPacNetAmt) ) );
    //}
    if ( !boolEurCert || !boolZeroRat ) {
      param.setSrvMemBSTaxes( "0" );
    }
    else {
      double srvMemBsNetAmt = 0;
      double srvMemBsAmt = 0;
      srvMemBsNetAmt = CommonUtils.intNvl( param.getSrvMemBSNetAmt() );
      srvMemBsAmt = CommonUtils.intNvl( param.getSrvMemBSAmt() );
      srvMemBsNetAmt = Math.round( (double) ( srvMemBsAmt ) * 100 ) / 100;
      param.setSrvMemBSNetAmt( String.valueOf( srvMemBsNetAmt ) );
      param.setSrvMemBSTaxes( String.valueOf( srvMemBsAmt - srvMemBsNetAmt ) );
    }
    // Get SMQ No
    preInsMap.put( "DOCNO", "20" );
    EgovMap docNoMap = eSVMApiMapper.getSMQDocNo( preInsMap );
    param.setSrvMemQuotNo( docNoMap.get( "docno" ).toString() );
    rtn.setDocno( docNoMap.get( "docno" ).toString() );
    // Get SAL0093D ID
    String SAL0093D_SEQ = eSVMApiMapper.getSAL0093D_SEQ();
    if ( null == SAL0093D_SEQ ) {
      throw new ApplicationException( AppConstants.FAIL, "Failed to obtain sequence number." );
    }
    param.setSal93Seq( SAL0093D_SEQ );
    // insertQuotationInfo
    eSVMApiMapper.insertSal93D( eSVMApiForm.createMap( param ) );
    logger.debug( "saveQuotationReq :: isFilterCharge :: " + param.getIsFilterCharge() );
    if ( "TRUE".equals( param.getIsFilterCharge() ) ) {
      Map<String, Object> spFilterMap = new HashMap<String, Object>();
      spFilterMap.put( "salesOrdId", param.getSrvSalesOrderId() );
      spFilterMap.put( "promoId", param.getSrvPromoId() );
      logger.debug( "saveQuotationReq :: call getSVMFilterCharge" );
      eSVMApiMapper.getSVMFilterCharge( spFilterMap );
      List<EgovMap> list = (List<EgovMap>) spFilterMap.get( "p1" );
      EgovMap eFilterMap = null;
      if ( list.size() > 0 ) {
        logger.debug( "saveQuotationReq :: eFilterMap List.size > 0" );
        for ( int i = 0; i < list.size(); i++ ) {
          eFilterMap = new EgovMap();
          Map rMap = (Map) list.get( i );
          eFilterMap.put( "srvMemQuotFilterID", SAL0093D_SEQ );
          eFilterMap.put( "stkID", rMap.get( "filterId" ) );
          eFilterMap.put( "stkPeriod", rMap.get( "lifePriod" ) );
          eFilterMap.put( "stkLastChangeDate", rMap.get( "lastChngDt" ) );
          eFilterMap.put( "stkFilterPrice", rMap.get( "oriPrc" ) );
          eFilterMap.put( "stkChargePrice", Math.floor( Double.parseDouble( rMap.get( "prc" ).toString() ) ) );
          if ( !boolZeroRat || !boolEurCert ) {
            double chargePrice = Math.floor( Double.parseDouble( rMap.get( "prc" ).toString() ) );
            double stkNetAmt = Math.floor( (float) chargePrice * 100 ) / 100;
            eFilterMap.put( "stkChargePrice", stkNetAmt );
            eFilterMap.put( "stkNetAmt", stkNetAmt );
            eFilterMap.put( "stkTaxes", "0" );
          }
          else {
            double chargePrice = Math.floor( Double.parseDouble( rMap.get( "prc" ).toString() ) );
            double stkNetAmt = 0;
            stkNetAmt = Math.floor( (float) chargePrice * 100 ) / 100;
            eFilterMap.put( "stkNetAmt", stkNetAmt );
            eFilterMap.put( "stkTaxes", chargePrice - stkNetAmt );
          }
          // insertSrvMembershipQuot_Filter
          eSVMApiMapper.insertSal94D( eFilterMap );
        }
      }
    }
    return rtn;
  }

  @Override
  public eSVMApiDto cancelSMQ( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    logger.debug( "param :: {}", param );
    eSVMApiDto rtn = new eSVMApiDto();
    // Deactivate SAL0093D - Update SRV_QUOT_STUS_ID = 21
    eSVMApiMapper.cancelSal93( eSVMApiForm.createMap( param ) );
    // Deactivate SAL0298D - Update STUS = 21 (If PSM exist)
    if ( param.getPsmId() != 0 ) {
      logger.debug( "psmId :: " + String.valueOf( param.getPsmId() ) );
      eSVMApiMapper.cancelSal298( eSVMApiForm.createMap( param ) );
    }
    return rtn;
  }

  @Override
  public int insertUploadPaymentFile( List<FileVO> list, eSVMApiDto param ) {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getUserId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "userId value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getFileKeySeq() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "fileKeySeq value does not exist." );
    }
    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put( "_USER_ID", param.getUserId() );
    LoginVO loginVO = loginMapper.selectLoginInfoById( loginInfoMap );
    if ( null == loginVO || CommonUtils.isEmpty( loginVO.getUserId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "UserID is null." );
    }
    int fileGroupKey = 0;
    if ( CommonUtils.isEmpty( param.getAtchFileGrpId() ) || param.getAtchFileGrpId() == 0 ) {
      fileGroupKey = eSVMApiMapper.selectFileGroupKey();
    }
    else {
      fileGroupKey = param.getAtchFileGrpId();
    }
    for ( FileVO data : list ) {
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileName", data.getAtchFileName() );
      sys0071D.put( "fileSubPath", data.getFileSubPath() );
      sys0071D.put( "physiclFileName", data.getPhysiclFileName() );
      sys0071D.put( "fileExtsn", data.getFileExtsn() );
      sys0071D.put( "fileSize", data.getFileSize() );
      sys0071D.put( "filePassword", null );
      sys0071D.put( "fileUnqKey", null );
      sys0071D.put( "fileKeySeq", param.getFileKeySeq() );
      int saveCnt = eSVMApiMapper.insertSYS0071D( sys0071D );
      if ( saveCnt == 0 ) {
        throw new ApplicationException( AppConstants.FAIL, "Insert Exception." );
      }
      if ( CommonUtils.isEmpty( sys0071D.get( "atchFileId" ) ) ) {
        throw new ApplicationException( AppConstants.FAIL, "atchFileId value does not exist." );
      }
      Map<String, Object> sys0070M = new HashMap<String, Object>();
      sys0070M.put( "atchFileGrpId", fileGroupKey );
      sys0070M.put( "atchFileId", sys0071D.get( "atchFileId" ) );
      sys0070M.put( "chenalType", FileType.MOBILE.getCode() );
      sys0070M.put( "crtUserId", loginVO.getUserId() );
      sys0070M.put( "updUserId", loginVO.getUserId() );
      saveCnt = eSVMApiMapper.insertSYS0070M( sys0070M );
      if ( saveCnt == 0 ) {
        throw new ApplicationException( AppConstants.FAIL, "Insert Exception." );
      }
    }
    return fileGroupKey;
  }

  @Override
  public eSVMApiDto insertPSM( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    logger.debug( "param :: {}", param );
    // get PSM_ID, PSM_NO and set into DTO
    int psmId = eSVMApiMapper.getSal298Seq();
    param.setPsmId( psmId );
    String psmDocNo = eSVMApiMapper.getPsmDocNo();
    param.setPsmNo( psmDocNo );
    // insert SAL0298D
    eSVMApiMapper.insertSal298D( eSVMApiForm.createMap( param ) );
    // insert PAY0312D
    eSVMApiMapper.insertPay312D( eSVMApiForm.createMap( param ) );
    // Skip Notifications if PO
    if ( !"6506".equals( String.valueOf( param.getPayMode() ) )
      && !"6528".equals( String.valueOf( param.getPayMode() ) ) ) {
      this.sendSms( eSVMApiForm.createMap( param ) );
      try {
        this.sendEmail( eSVMApiForm.createMap( param ) );
      }
      catch ( Exception e ) {
        logger.error( "EMAIL SENDING PROCESS ENCOUNTERED ERROR: " + e.getMessage() );
      }
    }
    eSVMApiDto rtn = new eSVMApiDto();
    rtn.setPsmNo( psmDocNo );
    return rtn;
  }

  public void sendSms( Map<String, Object> params ) {
    SmsVO sms = new SmsVO( Integer.parseInt( params.get( "regId" ).toString() ), 975 );
    String smsTemplate = eSVMApiMapper.getSmsTemplate( params );
    String smsNo = "";
    params.put( "smsTemplate", smsTemplate );
    if ( !"".equals( CommonUtils.nvl( params.get( "sms1" ) ) ) ) {
      smsNo = CommonUtils.nvl( params.get( "sms1" ) );
    }
    if ( !"".equals( CommonUtils.nvl( params.get( "sms2" ) ) ) ) {
      if ( !"".equals( CommonUtils.nvl( smsNo ) ) ) {
        smsNo += "|!|" + CommonUtils.nvl( params.get( "sms2" ) );
      }
      else {
        smsNo = CommonUtils.nvl( params.get( "sms2" ) );
      }
    }
    if ( !"".equals( CommonUtils.nvl( smsNo ) ) ) {
      sms.setMessage( CommonUtils.nvl( smsTemplate ) );
      sms.setMobiles( CommonUtils.nvl( smsNo ) );
      sms.setRemark( "SMS E-SVM PAYMENT VIA MOBILE APPS" );
      sms.setRefNo( CommonUtils.nvl( params.get( "mobTicketNo" ) ) );
      SmsResult smsResult = adaptorService.sendSMS( sms );
      logger.debug( " smsResult : {}", smsResult.toString() );
    }
  }

  public void sendEmail( Map<String, Object> params ) {
    EmailVO email = new EmailVO();
    String emailTitle = eSVMApiMapper.getEmailTitle( params );
    Map<String, Object> additionalParam = (Map<String, Object>) eSVMApiMapper.getEmailDetails( params );
    params.putAll( additionalParam );
    List<String> emailNo = new ArrayList<String>();
    if ( !"".equals( CommonUtils.nvl( params.get( "email1" ) ) ) ) {
      emailNo.add( CommonUtils.nvl( params.get( "email1" ) ) );
    }
    if ( !"".equals( CommonUtils.nvl( params.get( "email2" ) ) ) ) {
      emailNo.add( CommonUtils.nvl( params.get( "email2" ) ) );
    }
    email.setTo( emailNo );
    email.setHtml( true );
    email.setSubject( emailTitle );
    email.setHasInlineImage( true );
    boolean isResult = false;
    // TODO
    // EmailTemplateType.E_TEMPORARY_RECEIPT
    isResult = adaptorService.sendEmail( email, false, EmailTemplateType.E_SVM_RECEIPT, params );
  }

  @Override
  public List<EgovMap> selectPSMList( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getReqstDtFrom() ) || CommonUtils.isEmpty( param.getReqstDtTo() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "Request Date  does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getSelectType() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "Select Type value does not exist." );
    }
    else {
      if ( ( "2" ).equals( param.getSelectType() ) && param.getSelectKeyword().length() < 5 ) {
        throw new ApplicationException( AppConstants.FAIL, "Please enter at least 5 characters." );
      }
    }
    if ( CommonUtils.isEmpty( param.getRegId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "User ID value does not exist." );
    }
    return eSVMApiMapper.selectPSMList( eSVMApiForm.createMap( param ) );
  }

  @Override
  public List<EgovMap> selectESvmAttachment( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getAtchFileGrpId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "Attachment ID does not exist." );
    }
    return eSVMApiMapper.selectESvmAttachment( eSVMApiForm.createMap( param ) );
  }

  @Override
  public eSVMApiDto removePsmAttachment( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    logger.debug( "===== serviceImpl.removePsmAttachment =====" );
    logger.debug( "param :: {}", param );
    eSVMApiDto rtn = new eSVMApiDto();
    if ( CommonUtils.isNotEmpty( param.getAtchFileSvmF() ) && param.getAtchFileSvmF() > 0 ) {
      logger.debug( "delete sys71 svmf cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFileSvmF() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    if ( CommonUtils.isNotEmpty( param.getAtchFileSvmTnc() ) && param.getAtchFileSvmTnc() > 0 ) {
      logger.debug( "delete sys71 svmtnc cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFileSvmTnc() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    if ( CommonUtils.isNotEmpty( param.getAtchFilePo() ) && param.getAtchFilePo() > 0 ) {
      logger.debug( "delete sys71 po cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFilePo() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    if ( CommonUtils.isNotEmpty( param.getAtchFileNricCrcF() ) && param.getAtchFileNricCrcF() > 0 ) {
      logger.debug( "delete sys71 nriccrcf cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFileNricCrcF() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    if ( CommonUtils.isNotEmpty( param.getAtchFileNricCrcB() ) && param.getAtchFileNricCrcB() > 0 ) {
      logger.debug( "delete sys71 nriccrcb cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFileNricCrcB() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    if ( CommonUtils.isNotEmpty( param.getAtchFileTrxSlip() ) && param.getAtchFileTrxSlip() > 0 ) {
      logger.debug( "delete sys71 trxslip cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFileTrxSlip() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    if ( CommonUtils.isNotEmpty( param.getAtchFileChqImg() ) && param.getAtchFileChqImg() > 0 ) {
      logger.debug( "delete sys71 chqimg cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFileChqImg() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    if ( CommonUtils.isNotEmpty( param.getAtchFileOther1() ) && param.getAtchFileOther1() > 0 ) {
      logger.debug( "delete sys71 other1 cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFileOther1() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    if ( CommonUtils.isNotEmpty( param.getAtchFileOther2() ) && param.getAtchFileOther2() > 0 ) {
      logger.debug( "delete sys71 other2 cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFileOther2() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    if ( CommonUtils.isNotEmpty( param.getAtchFileOther3() ) && param.getAtchFileOther3() > 0 ) {
      logger.debug( "delete sys71 other3 cp" );
      Map<String, Object> sys0071D = new HashMap<String, Object>();
      sys0071D.put( "atchFileId", param.getAtchFileOther3() );
      int saveCnt = eSVMApiMapper.deleteSYS0071D( sys0071D );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Delete Exception." );
      }
    }
    return rtn;
  }

  @Override
  public int updatePaymentUploadFile( List<FileVO> list, eSVMApiDto param ) {
    logger.debug( "===== serviceImpl.updatePaymentUploadFile =====" );
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    /*
     * if(CommonUtils.isEmpty(param.getUserId())) { throw new
     * ApplicationException(AppConstants.FAIL, "userId value does not exist."); }
     */
    if ( CommonUtils.isEmpty( param.getAtchFileGrpId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "atchFileGrpId value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getCurAtchFileGrpId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "atchFileGrpId value does not exist." );
    }
    /*
     * if(CommonUtils.isEmpty(param.getFileKeySeq())) { throw new
     * ApplicationException(AppConstants.FAIL, "fileKeySeq value does not exist."); }
     * if(CommonUtils.isEmpty(param.getSaveFlag())) { throw new
     * ApplicationException(AppConstants.FAIL, "saveFlag value does not exist."); }
     */
    logger.debug( "param :: {}", param );
    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put( "_USER_ID", param.getUserId() );
    LoginVO loginVO = loginMapper.selectLoginInfoById( loginInfoMap );
    if ( null == loginVO || CommonUtils.isEmpty( loginVO.getUserId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "UserID is null." );
    }
    // SAL0903.js :: btnUpdate
    // To remove existing's sequence and update newly uploaded files's sequence
    List<EgovMap> newFile = eSVMApiMapper.getNewUploads( param.getCurAtchFileGrpId() ); // Newly uploaded file list
    logger.debug( "newFile List size :: " + String.valueOf( newFile.size() ) );
    // Loop newly uploaded file list
    for ( int i = 0; i < newFile.size(); i++ ) {
      // Remove File from existing
      EgovMap nFile = newFile.get( i );
      int fileSeq = Integer.parseInt( nFile.get( "fileKeySeq" ).toString() );
      int fileId = Integer.parseInt( nFile.get( "atchFileId" ).toString() );
      Map<String, Object> fileMap = new HashMap<String, Object>();
      fileMap.put( "eAtchFileGrpId", param.getAtchFileGrpId() );
      fileMap.put( "nAtchFileGrpId", param.getCurAtchFileGrpId() );
      fileMap.put( "fileSeq", fileSeq );
      fileMap.put( "nAtchFileId", fileId );
      // Get Existing File ID by FILE_KEY_SEQ
      EgovMap existFile = eSVMApiMapper.getOldUploads( fileMap );
      if ( existFile != null ) {
        // File sequence to replace with newer upload
        fileMap.put( "atchFileId", existFile.get( "atchFileId" ) );
        // Delete from SYS0070M
        eSVMApiMapper.deleteSYS0070M( fileMap );
        // Delete from SYS0071D
        eSVMApiMapper.deleteSYS0071D( fileMap );
      }
      // Update New File's ATCH_FILE_GRP_ID in SYS0070M to Existing File's ATCH_FILE_GRP_ID
      eSVMApiMapper.updateSYS0070M( fileMap );
    }
    /*
     * for(FileVO data : list) { Map<String, Object> sys0071D = new HashMap<String, Object>();
     * Map<String, Object> sys0070M = new HashMap<String, Object>();
     * if(param.getSaveFlag().equals("I")) { logger.debug(
     * "===== serviceImpl.updatePaymentUploadFile :: saveFlag : I =====");
     * sys0071D.put("atchFileName", data.getAtchFileName()); sys0071D.put("fileSubPath",
     * data.getFileSubPath()); sys0071D.put("physiclFileName", data.getPhysiclFileName());
     * sys0071D.put("fileExtsn", data.getFileExtsn()); sys0071D.put("fileSize", data.getFileSize());
     * sys0071D.put("filePassword", null); sys0071D.put("fileUnqKey", null);
     * sys0071D.put("fileKeySeq", param.getFileKeySeq()); int saveCnt =
     * eSVMApiMapper.insertSYS0071D(sys0071D); if(saveCnt == 0) { throw new
     * ApplicationException(AppConstants.FAIL, "Insert SYS0071D Exception"); }
     * if(CommonUtils.isEmpty(sys0071D.get("atchFileId"))) { throw new
     * ApplicationException(AppConstants.FAIL, "atchFileId value does not exist."); }
     * sys0070M.put("atchFileGrpId", param.getAtchFileGrpId()); sys0070M.put("atchFileId",
     * sys0071D.get("atchFileId")); sys0070M.put("chenalType", FileType.MOBILE.getCode());
     * sys0070M.put("crtUserId", loginVO.getUserId()); sys0070M.put("updUserId",
     * loginVO.getUserId()); saveCnt = eSVMApiMapper.insertSYS0070M(sys0070M); if (saveCnt == 0) {
     * throw new ApplicationException(AppConstants.FAIL, "Insert Exception."); } } else
     * if(param.getSaveFlag().equals("U")) { logger.debug(
     * "===== serviceImpl.updatePaymentUploadFile :: saveFlag : U =====");
     * sys0071D.put("atchFileId", param.getAtchFileId()); sys0071D.put("atchFileName",
     * data.getAtchFileName()); sys0071D.put("fileSubPath", data.getFileSubPath());
     * sys0071D.put("physiclFileName", data.getPhysiclFileName()); sys0071D.put("fileExtsn",
     * data.getFileExtsn()); sys0071D.put("fileSize", data.getFileSize()); int saveCnt =
     * eSVMApiMapper.updateSYS0071D(sys0071D); if (saveCnt == 0) { throw new
     * ApplicationException(AppConstants.FAIL, "Insert Exception."); } sys0070M.put("atchFileGrpId",
     * param.getAtchFileGrpId()); sys0070M.put("atchFileId", param.getAtchFileId());
     * sys0070M.put("updUserId", loginVO.getUserId()); saveCnt =
     * eSVMApiMapper.updateSYS0070M(sys0070M); if (saveCnt == 0) { throw new
     * ApplicationException(AppConstants.FAIL, "Insert Exception."); } } else if
     * (param.getSaveFlag().equals("D")) { throw new ApplicationException(AppConstants.FAIL,
     * "saveFlag value does not exist."); } else { throw new ApplicationException(AppConstants.FAIL,
     * "saveFlag value does not exist."); } }
     */
    return param.getAtchFileGrpId();
  }

  @Override
  public eSVMApiDto updatePaymentUploadFile_1( eSVMApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getAtchFileGrpId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "atchFileGrpId value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getCurAtchFileGrpId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "atchFileGrpId value does not exist." );
    }
    logger.debug( "param :: {}", param );
    List<EgovMap> newFile = eSVMApiMapper.getNewUploads( param.getCurAtchFileGrpId() ); // Newly uploaded file list
    logger.debug( "newFile List size :: " + String.valueOf( newFile.size() ) );
    // Loop newly uploaded file list
    for ( int i = 0; i < newFile.size(); i++ ) {
      // Remove File from existing
      EgovMap nFile = newFile.get( i );
      String fileSeq = nFile.get( "fileKeySeq" ).toString();
      String fileId = nFile.get( "atchFileId" ).toString();
      Map<String, Object> fileMap = new HashMap<String, Object>();
      fileMap.put( "eAtchFileGrpId", param.getAtchFileGrpId() );
      fileMap.put( "nAtchFileGrpId", param.getCurAtchFileGrpId() );
      fileMap.put( "fileSeq", fileSeq );
      fileMap.put( "nAtchFileId", fileId );
      // Get Existing File ID by FILE_KEY_SEQ
      EgovMap existFile = eSVMApiMapper.getOldUploads( fileMap );
      if ( existFile != null ) {
        // File sequence to replace with newer upload
        fileMap.put( "atchFileId", existFile.get( "atchFileId" ) );
        // Delete from SYS0070M
        eSVMApiMapper.deleteSYS0070M( fileMap );
        // Delete from SYS0071D
        eSVMApiMapper.deleteSYS0071D( fileMap );
      }
      // Update New File's ATCH_FILE_GRP_ID in SYS0070M to Existing File's
      // ATCH_FILE_GRP_ID
      eSVMApiMapper.updateSYS0070M( fileMap );
      // Back to processing status
      param.setProgressStatus( 104 );
      eSVMApiMapper.updateProgressStatusSal298D( eSVMApiForm.createMap( param ) );
    }
    eSVMApiDto rtn = new eSVMApiDto();
    rtn.setAtchFileGrpId( param.getAtchFileGrpId() );
    return rtn;
  }

  @Override
  public eSVMApiDto getMemberLevel( eSVMApiForm param )
    throws Exception {
    if ( null == param.getRegId() ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    eSVMApiDto getMemberLevel = eSVMApiDto.create( eSVMApiMapper.getMemberLevel( eSVMApiForm.createMap( param ) ) );
    return getMemberLevel;
  }

  @Override
  public eSVMApiDto selectEosEomDt( eSVMApiForm param )
    throws Exception {
    logger.debug( "========== selectEosEomDt ==========" );
    logger.debug( "========== param ==========" + param );
    EgovMap itemEomDt = eSVMApiMapper.selectEomDt( eSVMApiForm.createMap( param ) );
    param.setSalesOrdId( Integer.parseInt( itemEomDt.get( "salesOrdId" ).toString() ) );
    EgovMap itemSrvMemExprDt = eSVMApiMapper.selectMembershipExpiryDt( eSVMApiForm.createMap( param ) );
    EgovMap configMemExpEomDurMth = eSVMApiMapper.selectConfigEomDur( eSVMApiForm.createMap( param ) );
    int appType = Integer.parseInt( itemEomDt.get( "appType" ).toString() );
    String servicePacIdExist = eSVMApiMapper.getServicePacIdExist( itemEomDt.get( "salesOrdId" ).toString() );
    int configMemExpMth = Integer.parseInt( configMemExpEomDurMth.get( "svmMemExp" ).toString() );
    int configEomDurMth = Integer.parseInt( configMemExpEomDurMth.get( "svmEom" ).toString() );
    LocalDate today = LocalDate.now();
    LocalDate srvMemExprDt = null;
    LocalDate srvPrdEomDt = null;
    int errorCode = 0;
    String errorHeader = null;
    String errorMsg = null;
    logger.debug( "========== itemSrvMemExprDt ==========" + itemSrvMemExprDt );
    // Check for service membership
    if ( appType == 66 ) {
      if ( itemSrvMemExprDt != null && itemSrvMemExprDt.containsKey( "srvMemExprDt" ) ) {
        srvMemExprDt = LocalDate.parse( itemSrvMemExprDt.get( "srvMemExprDt" ).toString() );
        int diffSrvMemExpr = Months.monthsBetween( today, srvMemExprDt ).getMonths();
        if ( diffSrvMemExpr > configMemExpMth ) // Membership expiration date more than 6 months
        {
          errorCode = 99;
          errorHeader = "Early Subscription > " + configMemExpMth + " months";
          errorMsg = "The order is too early to subscribe for SVM, kindly subscribe the membership within "
            + configMemExpMth + " months period from the order expired date.";
        }
      }
    }
    else {
      if ( itemSrvMemExprDt != null && itemSrvMemExprDt.containsKey( "srvMemExprDt" ) ) {
        srvMemExprDt = LocalDate.parse( itemSrvMemExprDt.get( "srvMemExprDt" ).toString() );
        int diffSrvMemExpr = Months.monthsBetween( today, srvMemExprDt ).getMonths();
        if ( diffSrvMemExpr > configMemExpMth ) // Membership expiration date more than 6 months
        {
          if ( servicePacIdExist.equals( "Y" ) ) {
            errorCode = 99;
            errorHeader = "Early Subscription > " + configMemExpMth + " months";
            errorMsg = "The order is too early to subscribe for SVM, kindly subscribe the membership within "
              + configMemExpMth + " months period from the order expired date.";
          }
        }
      }
      else {
        if ( servicePacIdExist.equals( "Y" ) ) {
          errorCode = 99;
          errorHeader = "Early Subscription > " + configMemExpMth + " months";
          errorMsg = "The order is too early to subscribe for SVM, kindly subscribe the membership within "
            + configMemExpMth + " months period from the order expired date.";
        }
      }
    }
    logger.debug( "========== itemEomDt ==========" + itemEomDt );
    // Check for EOM
    if ( itemEomDt.containsKey( "eomDate" ) == true ) {
      srvPrdEomDt = LocalDate.parse( itemEomDt.get( "eomDate" ).toString() );
      int diffSrvPrdEom = Months.monthsBetween( today, srvPrdEomDt ).getMonths();
      if ( diffSrvPrdEom < configEomDurMth ) {
        errorCode = 99;
        errorHeader = "End of Membership";
        errorMsg = "The order is end of membership soon (within " + configEomDurMth
          + " months period) - not entitled to subscribe SVM. Kindly suggest customer to do Ex-Trade for this model.";
      }
    }
    eSVMApiDto rtn = new eSVMApiDto();
    rtn.setErrorCode( errorCode );
    rtn.setErrorHeader( errorHeader );
    rtn.setErrorMsg( errorMsg );
    return rtn;
  }
}
