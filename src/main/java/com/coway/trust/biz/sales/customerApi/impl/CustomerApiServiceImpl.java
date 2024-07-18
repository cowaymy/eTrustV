package com.coway.trust.biz.sales.customerApi.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiDto;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;
import com.coway.trust.api.mobile.sales.customerApi.CustomerTierCatListApiDto;
import com.coway.trust.api.mobile.sales.customerApi.CustomerTierOrderListApiDto;
import com.coway.trust.api.mobile.sales.customerApi.CustomerTierPointApiDto;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.impl.CommonApiMapper;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.sales.customerApi.CustomerApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CustomerApiServiceImpl.java
 * @Description : TO-DO Class Description
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 16.    KR-JAEMJAEM:)   First creation
 * 2020. 04. 14.    MY-ONGHC         Restructure Messy Code
 *          </pre>
 */
@Service("CustomerApiService")
public class CustomerApiServiceImpl
  extends EgovAbstractServiceImpl
  implements CustomerApiService {
  @Resource(name = "CustomerApiMapper")
  private CustomerApiMapper customerApiMapper;

  @Resource(name = "CommonApiMapper")
  private CommonApiMapper commonApiMapper;

  @Resource(name = "commonApiService")
  private CommonApiService commonApiService;

  @Autowired
  private LoginMapper loginMapper;

  @Override
  public List<EgovMap> selectCustomerList( CustomerApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getSelectType() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "Select Type value does not exist." );
    }
    else {
      if ( ( "1" ).equals( param.getSelectType() ) && param.getSelectKeyword().length() < 5 ) {
        throw new ApplicationException( AppConstants.FAIL, "Please fill out at least five characters." );
      }
      if ( ( ( "2" ).equals( param.getSelectType() ) || ( "3" ).equals( param.getSelectType() ) )
        && CommonUtils.isEmpty( param.getSelectKeyword() ) ) {
        throw new ApplicationException( AppConstants.FAIL, "Select Keyword value does not exist." );
      }
    }
    if ( CommonUtils.isEmpty( param.getMemId() ) || param.getMemId() <= 0 ) {
      throw new ApplicationException( AppConstants.FAIL, "mdmId value does not exist." );
    }
    return customerApiMapper.selectCustomerList( CustomerApiForm.createMap( param ) );
  }

  @Override
  public EgovMap selectCustomerInfo( CustomerApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( String.valueOf( param.getCustId() ) ) ) {
      throw new ApplicationException( AppConstants.FAIL, "Customer ID value does not exist." );
    }
    if ( CommonUtils.isEmpty( String.valueOf( param.getCustAddId() ) ) ) {
      throw new ApplicationException( AppConstants.FAIL, "CustAdd ID value does not exist." );
    }
    return customerApiMapper.selectCustomerInfo( CustomerApiForm.createMap( param ) );
  }

  @Override
  public List<EgovMap> selectCustomerOrder( CustomerApiForm param )
    throws Exception {
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getCustId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "Customer ID value does not exist." );
    }
    return customerApiMapper.selectCustomerOrder( CustomerApiForm.createMap( param ) );
  }

  @Override
  public CustomerApiDto selectCodeList()
    throws Exception {
    CustomerApiDto rtn = new CustomerApiDto();
    List<EgovMap> selectCodeList = customerApiMapper.selectCodeList();
    List<CustomerApiDto> codeList = selectCodeList.stream().map( r -> CustomerApiDto.create( r ) )
                                                  .collect( Collectors.toList() );
    rtn.setCodeList( codeList );
    return rtn;
  }

  @Override
  public CustomerApiForm saveCustomer( CustomerApiForm param )
    throws Exception {
    /* DATA VERIFICATION */
    if ( null == param ) {
      throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getTypeId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "(Customer Type) Customer type value does not exist." );
    }
    else {
      if ( param.getTypeId() == 964 ) {
        if ( CommonUtils.isEmpty( param.getContactCustInitial() ) ) {
          throw new ApplicationException( AppConstants.FAIL,
                                          "(Basic Info) Customer contact person Initial value does not exist." );
        }
        if ( CommonUtils.isEmpty( param.getName() ) ) {
          throw new ApplicationException( AppConstants.FAIL, "(Basic Info) Customer name value does not exist." );
        }
        if ( CommonUtils.isEmpty( param.getNric() ) ) {
          throw new ApplicationException( AppConstants.FAIL, "(Basic Info) NRIC value does not exist." );
        }
        if ( CommonUtils.isEmpty( param.getDob() ) ) {
          throw new ApplicationException( AppConstants.FAIL, "(Basic Info) DOB value does not exist." );
        }
        if ( CommonUtils.isEmpty( param.getGender() ) ) {
          throw new ApplicationException( AppConstants.FAIL, "(Basic Info) Gender value does not exist." );
        }
        if ( CommonUtils.isEmpty( param.getNation() ) ) {
          throw new ApplicationException( AppConstants.FAIL, "(Basic Info) Nationality value does not exist." );
        }
        if ( CommonUtils.isEmpty( param.getRaceId() ) ) {
          throw new ApplicationException( AppConstants.FAIL, "(Basic Info) Race value does not exist." );
        }
        /*if ( CommonUtils.isEmpty( param.geteInvFlg() ) ) {
          throw new ApplicationException( AppConstants.FAIL,
                                          "(Basic Info) eInvoice Indicator value does not exist." );
        }*/
      }
      else if ( param.getTypeId() == 965 ) {
        if ( CommonUtils.isEmpty( param.getName() ) ) {
          throw new ApplicationException( AppConstants.FAIL, "(Basic Info) Customer name. value does not exist." );
        }
        if ( CommonUtils.isEmpty( param.getNric() ) ) {
          throw new ApplicationException( AppConstants.FAIL, "(Basic Info) Company number value does not exist." );
        }
        if ( CommonUtils.isEmpty( param.getTinNo() ) ) {
          throw new ApplicationException( AppConstants.FAIL,
                                          "(Basic Info) Tax Identification No. value does not exist." );
        }
        if ( CommonUtils.isEmpty( param.getReceivingMarketingMsgStatus() ) ) {
          throw new ApplicationException( AppConstants.FAIL,
                                          "(Basic Info) Receiving Marketing Message value does not exist." );
        }
        /*if ( CommonUtils.isEmpty( param.geteInvFlg() ) ) {
          throw new ApplicationException( AppConstants.FAIL,
                                          "(Basic Info) eInvoice Indicator value does not exist." );
        }*/
      }
      else {
        throw new ApplicationException( AppConstants.FAIL, "(Customer Type) Customer Type value does not exist." );
      }
    }
    if ( CommonUtils.isEmpty( param.getContactTelM1() ) && CommonUtils.isEmpty( param.getContactTelR() )
      && CommonUtils.isEmpty( param.getContactTelO() ) && CommonUtils.isEmpty( param.getContactTelf() ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Main Contact) Please enter at least one of the service contacts '#'." );
    }
    if ( CommonUtils.isEmpty( param.getContactTelM1() ) == false
      && ( param.getContactTelM1().substring( 0, 3 ) == "015" || param.getContactTelM1().substring( 0, 2 ) == "01" ) ) {
      throw new ApplicationException( AppConstants.FAIL, "(Main Contact) Invalid Mobile Number." );
    }
    if ( CommonUtils.isEmpty( param.getContactTelM1() ) == false
      && ( param.getContactTelM1().length() < 9 || param.getContactTelM1().length() > 12 ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Main Contact) Phone number length should be in length of 9, 10 or 11." );
    }
    if ( CommonUtils.isEmpty( param.getContactTelR() ) == false
      && ( param.getContactTelR().length() < 9 || param.getContactTelR().length() > 12 ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Main Contact) Residence number length should be in length of 9, 10 or 11." );
    }
    if ( CommonUtils.isEmpty( param.getContactTelO() ) == false
      && ( param.getContactTelO().length() < 9 || param.getContactTelO().length() > 12 ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Main Contact) Office number length should be in length of 9, 10 or 11." );
    }
    if ( CommonUtils.isEmpty( param.getContactTelf() ) == false
      && ( param.getContactTelf().length() < 9 || param.getContactTelf().length() > 12 ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Main Contact) Fax number length should be in length of 9, 10 or 11." );
    }
    if ( CommonUtils.isEmpty( param.getCareCntName() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "(Sercvie Contact) Customer name value does not exist." );
    }
    if ( CommonUtils.isEmpty( param.getCareCntTelM() ) && CommonUtils.isEmpty( param.getCareCntTelR() )
      && CommonUtils.isEmpty( param.getContactTelO() ) && CommonUtils.isEmpty( param.getContactTelf() ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Sercvie Contact) Please enter at least one of the service contacts '#'." );
    }
    if ( CommonUtils.isEmpty( param.getCareCntTelM() ) == false
      && ( param.getCareCntTelM().substring( 0, 3 ) == "015" || param.getCareCntTelM().substring( 0, 2 ) == "01" ) ) {
      throw new ApplicationException( AppConstants.FAIL, "(Sercvie Contact) Invalid Mobile Number." );
    }
    if ( CommonUtils.isEmpty( param.getCareCntTelM() ) == false
      && ( param.getCareCntTelM().length() < 9 || param.getCareCntTelM().length() > 12 ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Sercvie Contact) Phone number length should be in length of 9, 10 or 11." );
    }
    if ( CommonUtils.isEmpty( param.getCareCntTelR() ) == false
      && ( param.getCareCntTelR().length() < 9 || param.getCareCntTelR().length() > 12 ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Sercvie Contact) Residence number length should be in length of 9, 10 or 11." );
    }
    if ( CommonUtils.isEmpty( param.getCareCntTelO() ) == false
      && ( param.getCareCntTelO().length() < 9 || param.getCareCntTelO().length() > 12 ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Sercvie Contact) Office number length should be in length of 9, 10 or 11." );
    }
    if ( CommonUtils.isEmpty( param.getCareCntTelf() ) == false
      && ( param.getCareCntTelf().length() < 9 || param.getCareCntTelf().length() > 12 ) ) {
      throw new ApplicationException( AppConstants.FAIL,
                                      "(Sercvie Contact) Fax number length should be in length of 9, 10 or 11." );
    }
    if ( CommonUtils.isEmpty( param.getAddressAreaId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "(Installation Address) Please key in the postcode." );
    }
    if ( CommonUtils.isEmpty( param.getAddressAddrDtl() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "(Installation Address) Please key in the Address Line 1." );
    }
    Map<String, Object> loginInfoMap = new HashMap<String, Object>();
    loginInfoMap.put( "_USER_ID", param.getRegId() );
    LoginVO loginVO = loginMapper.selectLoginInfoById( loginInfoMap );
    if ( null == loginVO || CommonUtils.isEmpty( loginVO.getUserId() ) ) {
      throw new ApplicationException( AppConstants.FAIL, "User ID value does not exist." );
    }

    int custId = customerApiMapper.getCustId();
    if ( CommonUtils.isEmpty( custId ) ) {
      throw new ApplicationException( AppConstants.FAIL, "Fail to get Customer ID." );
    }

    String tinId = "";

    if ( !CommonUtils.isEmpty(CommonUtils.nvl( param.getTinNo() ))) {
      tinId = String.valueOf( customerApiMapper.getTinId());
      if ( CommonUtils.isEmpty( tinId ) ) {
        throw new ApplicationException( AppConstants.FAIL, "Fail to get TIN ID." );
      }
    }

    /* SAL0029D --ASIS_DB : WebDB ASIS_SCHEMA : dbo ASIS_TABLE : Customer */
    Map<String, Object> customerMap = new HashMap<String, Object>();
    // customerMap.put("stusCodeId", param.getStusCodeId());
    // customerMap.put("updDt", );
    // customerMap.put("renGrp", param.getRenGrp());
    // customerMap.put("pstTerms", param.getPstTerms());
    // customerMap.put("idOld", param.getIdOld());
    // customerMap.put("crtDt", );
    // customerMap.put("custVaNo", param.getCustVaNo());
    // customerMap.put("ficoScre", param.getFicoScre());
    customerMap.put( "custId", custId);
    customerMap.put( "isMobile", '1');
    customerMap.put( "name", param.getName() );
    customerMap.put( "nric", param.getNric() );
    customerMap.put( "nation", param.getNation() );
    customerMap.put( "dob", param.getDob() );
    customerMap.put( "gender", param.getGender() );
    customerMap.put( "raceId", param.getRaceId() );
    customerMap.put( "email", param.getEmail() );
    customerMap.put( "rem", param.getRem() );
    customerMap.put( "updUserId", loginVO.getUserId() );
    customerMap.put( "crtUserId", loginVO.getUserId() );
    customerMap.put( "typeId", param.getTypeId() );
    customerMap.put( "pasSportExpr", param.getPasSportExpr() );
    customerMap.put( "visaExpr", param.getVisaExpr() );
    customerMap.put( "corpTypeId", param.getCorpTypeId() );
    customerMap.put( "gstRgistNo", param.getGstRgistNo() );
    customerMap.put( "ctosDt", param.getCtosDt() );
    customerMap.put( "oldIc", param.getOldIc() );
    customerMap.put( "sstRegNo", param.getSstRegNo() );
    customerMap.put( "tinId", tinId );
    customerMap.put( "receivingMarketingMsgStatus", param.getReceivingMarketingMsgStatus() );
    int checkCnt = 0;
    if ( ( ( param.getNric() ).toUpperCase() ).contains( "TST" ) ) {
      checkCnt = 0;
    }
    else {
      checkCnt = customerApiMapper.selectNricNoCheck( customerMap );
    }
    // int checkCnt = customerApiMapper.selectNricNoCheck(customerMap);
    // //CustomerApi_SQL.xml
    if ( checkCnt != 0 ) {
      if ( param.getTypeId() == 964 ) {
        throw new ApplicationException( AppConstants.FAIL, "Duplicate NRIC." );
      }
      else if ( param.getTypeId() == 965 ) {
        throw new ApplicationException( AppConstants.FAIL, "Duplicate Company No." );
      }
      else {
        throw new ApplicationException( AppConstants.FAIL, "Duplicate NRIC." );
      }
    }
    // checkCnt = customerApiMapper.selectTelCheck(customerMap);
    // //CustomerApi_SQL.xml
    // if(checkCnt != 0){
    // throw new ApplicationException(AppConstants.FAIL, "NRIC duplicate.");
    // }
    int saveCnt = customerApiMapper.insertCustomer( customerMap ); // CustomerApi_SQL.xml
    if ( saveCnt != 1 || CommonUtils.isEmpty( customerMap.get( "custId" ) ) ) {
      throw new ApplicationException( AppConstants.FAIL, "Customer Exception." );
    }

    /* SAL0416D -- ASIS_DB : WebDB ASIS_SCHEMA : dbo ASIS_TABLE : CustTinNo. */
    //customerMap.put( "eInvFlg", param.geteInvFlg());
    if ( !CommonUtils.isEmpty(CommonUtils.nvl( param.getTinNo() ))) {
      customerMap.put( "tinNo", param.getTinNo() );

      saveCnt = customerApiMapper.insertCustomerTin( customerMap );
      if ( saveCnt != 1 ) {
        throw new ApplicationException( AppConstants.FAIL, "Customer Tin Exception." );
      }
    }

    /* SAL0027D -- ASIS_DB : WebDB ASIS_SCHEMA : dbo ASIS_TABLE : CustContact */
    Map<String, Object> contactMap = new HashMap<String, Object>();
    // contactMap.put("custCntcId", param.getCustCntcId());
    // contactMap.put("contactPos", param.getContactPos());
    // contactMap.put("contactTelM2", param.getContactTelM2());
    // contactMap.put("contactStusCodeId", param.getContactStusCodeId());
    // contactMap.put("updDt", );
    // contactMap.put("contactIdOld", param.getContactIdOld());
    // contactMap.put("contactDcm", param.getContactDcm());
    // contactMap.put("crtDt", );
    contactMap.put( "custId", customerMap.get( "custId" ) );
    contactMap.put( "contactName", param.getContactName() );
    contactMap.put( "contactCustInitial", param.getContactCustInitial() );
    contactMap.put( "contactNric", param.getContactNric() );
    contactMap.put( "contactTelM1", param.getContactTelM1() );
    contactMap.put( "contactTelO", param.getContactTelO() );
    contactMap.put( "contactTelR", param.getContactTelR() );
    contactMap.put( "contactTelf", param.getContactTelf() );
    contactMap.put( "contactDob", param.getContactDob() );
    contactMap.put( "contactGender", param.getContactGender() );
    contactMap.put( "contactRaceId", param.getContactRaceId() );
    contactMap.put( "contactEmail", param.getContactEmail() );
    contactMap.put( "updUserId", loginVO.getUserId() );
    contactMap.put( "contactDept", param.getContactDept() );
    contactMap.put( "crtUserId", loginVO.getUserId() );
    contactMap.put( "contactExt", param.getContactExt() );
    saveCnt = customerApiMapper.insertCustContact( contactMap ); // CustomerApi_SQL.xml
    if ( saveCnt != 1 ) {
      throw new ApplicationException( AppConstants.FAIL, "CustContact Exception." );
    }
    /*
     * SAL0026D -- ASIS_DB : WebDB ASIS_SCHEMA : dbo ASIS_TABLE : CustCareContact
     */
    Map<String, Object> custCareContactMap = new HashMap<String, Object>();
    // custCareContactMap.put("custCareCntId", param.getCustCareCntId());
    // custCareContactMap.put("careCntStusCodeId",
    // param.getCareCntStusCodeId());
    // contactMap.put("crtDt", );
    // contactMap.put("updDt", );
    custCareContactMap.put( "custId", customerMap.get( "custId" ) );
    custCareContactMap.put( "careCntName", param.getCareCntName() );
    custCareContactMap.put( "careCntCustInitial", param.getCareCntCustInitial() );
    custCareContactMap.put( "careCntTelM", param.getCareCntTelM() );
    custCareContactMap.put( "careCntTelO", param.getCareCntTelO() );
    custCareContactMap.put( "careCntTelR", param.getCareCntTelR() );
    custCareContactMap.put( "careCntExt", param.getCareCntExt() );
    custCareContactMap.put( "careCntEmail", param.getCareCntEmail() );
    custCareContactMap.put( "crtUserId", loginVO.getUserId() );
    custCareContactMap.put( "updUserId", loginVO.getUserId() );
    custCareContactMap.put( "careCntTelf", param.getCareCntTelf() );
    saveCnt = customerApiMapper.insertCustCareContact( custCareContactMap ); // CustomerApi_SQL.xml
    if ( saveCnt != 1 ) {
      throw new ApplicationException( AppConstants.FAIL, "CustCareContact Exception." );
    }
    /* SAL0023D -- ASIS_DB : WebDB ASIS_SCHEMA : dbo ASIS_TABLE : CustAddress */
    Map<String, Object> custAddressMap = new HashMap<String, Object>();
    // custAddressMap.put("custAddId", param.getCustAddId());
    // custAddressMap.put("addressTel", param.getAddressTel());
    // custAddressMap.put("addressFax", param.getAddressFax());
    // custAddressMap.put("addressStusCodeId", param.getAddressStusCodeId());
    // custAddressMap.put("updDt", );
    // custAddressMap.put("addressIdOld", param.getAddressIdOld());
    // custAddressMap.put("addressSoId", param.getAddressSoId());
    // custAddressMap.put("addressIdcm", param.getAddressIdcm());
    // custAddressMap.put("crtDt", );
    // custAddressMap.put("addressAdd2", param.getAddressAdd2());
    // custAddressMap.put("addressAdd3", param.getAddressAdd3());
    // custAddressMap.put("addressAdd4", param.getAddressAdd4());
    // custAddressMap.put("addressPostcodeid", param.getAddressPostcodeid());
    // custAddressMap.put("addressPostcode", param.getAddressPostcode());
    // custAddressMap.put("addressAreaid", param.getAddressAreaid());
    // custAddressMap.put("addressArea", param.getAddressArea());
    // custAddressMap.put("addressAtateid", param.getAddressAtateid());
    // custAddressMap.put("addressCountryid", param.getAddressCountryid());
    custAddressMap.put( "custId", customerMap.get( "custId" ) );
    custAddressMap.put( "addressNric", param.getAddressNric() );
    custAddressMap.put( "addressRem", param.getAddressRem() );
    custAddressMap.put( "updUserId", loginVO.getUserId() );
    custAddressMap.put( "crtUserId", loginVO.getUserId() );
    custAddressMap.put( "addressAreaId", param.getAddressAreaId() );
    custAddressMap.put( "addressAddrDtl", param.getAddressAddrDtl() );
    custAddressMap.put( "addressStreet", param.getAddressStreet() );
    custAddressMap.put( "addressAdd1", param.getAddressAdd1() );
    saveCnt = customerApiMapper.insertCustAddress( custAddressMap ); // CustomerApi_SQL.xml
    if ( saveCnt != 1 ) {
      throw new ApplicationException( AppConstants.FAIL, "CustAddress Exception." );
    }
    return CustomerApiForm.create( customerMap );
  }

  @Override
  public Map<String, Object> selectCustomerTierPoint( HttpServletRequest request, CustomerApiForm param )
    throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0",
      sysUserId = "0";
    // default courseCloseDt
    String currentDate = CommonUtils.getNowDate();
    String defaultCloseDt = CommonUtils.getAddDay( currentDate, 60, "YYYYMMDD" ); // defaultly added 60 days to close date
    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();
    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = new HashMap<>();
    String key = request.getHeader( "key" );
    reqPrm.put( "key", key );
    Map<String, Object> tierFullDetails = new HashMap<String, Object>();
    Map<String, Object> cnvTierFullDetails = new HashMap<String, Object>();
    try {
      int created = 0;
      access = commonApiMapper.checkAccess( reqPrm );
      if ( access == null ) {
        code = String.valueOf( AppConstants.RESPONSE_CODE_UNAUTHORIZED );
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else {
        if ( null == param ) {
          throw new ApplicationException( AppConstants.FAIL, "Parameter value does not exist." );
        }
        if ( CommonUtils.isEmpty( String.valueOf( param.getCustId() ) ) ) {
          throw new ApplicationException( AppConstants.FAIL, "Customer ID value does not exist." );
        }
        int exist = customerApiMapper.selectCustCheck( CustomerApiForm.createMap( param ) );
        if ( exist != 1 ) {
          throw new ApplicationException( AppConstants.FAIL, "Customer ID does not exist." );
        }
        EgovMap tierMaster = customerApiMapper.selectCustomerTierMaster( CustomerApiForm.createMap( param ) );
        tierFullDetails = tierMaster;
        List<EgovMap> mapListCatgryList = new ArrayList<>();
        List<EgovMap> catgryList = customerApiMapper.selectCustomerTierCatgryList( CustomerApiForm.createMap( param ) );
        mapListCatgryList = catgryList;
        List<CustomerTierCatListApiDto> catlist = new ArrayList<>();
        for ( EgovMap alist : catgryList ) {
          if ( alist.get( "codeId" ).toString().equals( "1" ) ) {
            List<CustomerTierOrderListApiDto> orderListDetails = customerApiMapper.selectCustomerTierOrderList( CustomerApiForm.createMap( param ) );
            alist.put( "orderList", orderListDetails );
          }
          CustomerTierCatListApiDto catDto = CustomerTierCatListApiDto.create( alist );
          catlist.add( catDto );
        }
        tierFullDetails.put( "categoryList", catlist );
        CustomerTierPointApiDto custTierDto = CustomerTierPointApiDto.create( tierFullDetails );
        ObjectMapper oMapper = new ObjectMapper();
        cnvTierFullDetails = oMapper.convertValue( custTierDto, Map.class );
        code = String.valueOf( AppConstants.RESPONSE_CODE_SUCCESS );
        message = String.valueOf( AppConstants.RESPONSE_DESC_SUCCESS );
      }
    }
    catch ( Exception e ) {
      code = String.valueOf( AppConstants.RESPONSE_CODE_INVALID );
      message = StringUtils.substring( e.getMessage(), 0, 4000 );
      System.out.println();
    }
    finally {
      stopWatch.stop();
      respTm = stopWatch.toString();
    }
    return commonApiService.rtnRespMsg( request, code, message, respTm, CustomerApiForm.createMap( param ),
                                        cnvTierFullDetails, apiUserId );
  }
}
