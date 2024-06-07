package com.coway.trust.biz.supplement.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.codehaus.jettison.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
import com.coway.trust.biz.supplement.impl.SupplementUpdateMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.biz.sales.pos.impl.PosServiceImpl;
import com.coway.trust.biz.sales.pos.impl.PosStockMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.cmmn.model.EmailVO;
import java.util.Arrays;
import com.coway.trust.web.common.ReportController.ViewType;
import com.coway.trust.web.common.ReportController;
import com.coway.trust.web.common.visualcut.ReportBatchController;
import com.coway.trust.biz.common.ReportBatchService;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.biz.payment.payment.service.impl.PaymentApiMapper;

import java.io.IOException;
import java.text.ParseException;

import static com.coway.trust.AppConstants.EMAIL_SUBJECT;
import static com.coway.trust.AppConstants.EMAIL_TEXT;
import static com.coway.trust.AppConstants.EMAIL_TO;
import static com.coway.trust.AppConstants.MSG_NECESSARY;
import static com.coway.trust.AppConstants.REPORT_CLIENT_DOCUMENT;
import static com.coway.trust.AppConstants.REPORT_DOWN_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_FILE_NAME;
import static com.coway.trust.AppConstants.REPORT_VIEW_TYPE;




@Service("supplementUpdateService")
public class SupplementUpdateServiceImpl extends EgovAbstractServiceImpl implements SupplementUpdateService {

  private static final Logger LOGGER = LoggerFactory.getLogger(SupplementUpdateServiceImpl.class);

  @Resource(name = "posMapper")
  private PosMapper posMapper;

  @Resource(name = "posStockMapper")
  private PosStockMapper posStockMapper;

  @Resource(name = "supplementUpdateMapper")
  private SupplementUpdateMapper supplementUpdateMapper;

  @Autowired
  private AdaptorService adaptorService;

  @Resource(name = "paymentApiMapper")
  private PaymentApiMapper paymentApiMapper;

  @Resource(name = "commonService")
  private CommonService commonService;

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
  public List<EgovMap> selectSupDelStus() {
    return supplementUpdateMapper.selectSupDelStus();
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
	public int updateRefStgStatus(Map<String, Object> params) {
      int result = supplementUpdateMapper.updateRefStgStatus(params);
		return result;
	}*/

  public Map<String, Object> updateRefStgStatus (Map<String, Object> params) throws Exception {
	  Map<String, Object> rtnMap = new HashMap<>();
	  Map<String, Object> stoEntry = new HashMap<String, Object>();

	  try{
	  int result = supplementUpdateMapper.updateRefStgStatus(params);
	  EgovMap stoSup = supplementUpdateMapper.getStoSup(params);

	  LOGGER.debug(" params stoSupNo =========>"+ stoSup.get("reqstNo"));
	  LOGGER.debug(" params userId =========>"+ params.get("userId"));


	  stoEntry.put("custName", params.get("custName"));
	  stoEntry.put("supRefId", params.get("supRefId"));
	  stoEntry.put("supRefNo", params.get("supRefNo"));
	  stoEntry.put("reqstNo", stoSup.get("reqstNo"));
	  stoEntry.put("userId", params.get("userId"));
	  params.put("emailType", "1");

	  stoPreSupp(stoEntry);
	  rtnMap.put("logError", "000");

	  LOGGER.debug("Start send email=========");
	  this.sendEmail(params);
	  LOGGER.debug("Done send email=========l");

	  } catch (Exception e) {
	      rtnMap.put("logError", "99");
	      rtnMap.put("message", "An error occurred: " + e.getMessage());
	      LOGGER.error("Error updating parcel tracking number...", e);
	    }

	  return rtnMap;
  }

  private void stoPreSupp( Map<String, Object> params) throws Exception {
	    Map<String, Object> logPram = new HashMap<>();

	    logPram.put("P_STO", params.get("reqstNo"));
	    logPram.put("P_USER", params.get("userId"));

	    supplementUpdateMapper.SP_STO_PRE_SUPP(logPram);

	    if (!"000".equals(logPram.get("p1"))) {
	     // rollBackSupplementTransaction(params);
	      throw new ApplicationException(AppConstants.FAIL, "SP_STO_PRC_SUPP - ERRCODE : " + logPram.get("p1"));
	      // throw new Exception("SP_STO_PRC_SUPP - ERRCODE : " + logPram.get("p1"));
	    }
	  }


  private void rollBackSupplementTransaction( Map<String, Object> params)
	      throws Exception {
	  LOGGER.info("############################ rollBackSupplementTransaction - params: {}", params);
	  supplementUpdateMapper.revertStgStus(params);
	  LOGGER.info("Complete reverted!..");
	  }

  @SuppressWarnings("unchecked")
  @Override
  public EgovMap updOrdDelStat( Map<String, Object> params ) throws IOException, JSONException, ParseException {
    if ( CommonUtils.nvl( params.get( "ords" ) ).equals( "" ) ) {
      throw new ApplicationException( AppConstants.FAIL, "NO ORDERS SELECTED TO PERFORM DELIVERY STATUS UPDATE." );
    }

    // LOOP SELECTED ORDERS
    List<Map<String, String>> ordsList = (List<Map<String, String>>) params.get( "ords" );
    int total = ordsList.size();
    int fail = 0;
    int success = 0;

    for ( Map<String, String> order : ordsList ) {
      String ordNo = order.get( "ordNo" ); // SUPPLEMENT ORDER NO.
      String trckNo = order.get( "trckNo" ); // SUPPLEMENT TRACKING NO.

      Map<String, Object> gDexPram = new HashMap<>();
      gDexPram.put( "consNo", CommonUtils.nvl( trckNo ) ); // CONSIGNMENT NO.
      gDexPram.put( "ordNo", CommonUtils.nvl( ordNo ) ); // SUPPLEMENT ORDER NO.

      // CALL GDEX GET DELIVERY STATUS AND DATE.
      EgovMap rtnData = commonService.getGdexShptDtl( gDexPram );
      if ( !"000".equals( rtnData.get( "status" ) ) ) {
        //throw new ApplicationException( AppConstants.FAIL, "gDEX - ERRCODE : " + rtnData.get( "message" ) );
        fail += 1;
        continue;
      }

      // UPDATE DELIVERY STATUS & DATE
      if ( CommonUtils.nvl( rtnData.get("value") ).equals( "" ) ) {
        //throw new ApplicationException( AppConstants.FAIL, "GDEX RESPONE DOES NOT CONTAIN VALUE." );
        fail += 1;
        continue;
      }

      Map<String, Object> extractedValueMap = (Map<String, Object>) rtnData.get("value");
      extractedValueMap.put( "userId", CommonUtils.nvl(params.get( "userId" )));

      if (extractedValueMap.get( "latestEnumStatus" ).equals( 4 )) {
        extractedValueMap.put( "ordRefStat", "4");
        extractedValueMap.put( "ordRefStg", "99");
      }

      int count = supplementUpdateMapper.updOrdDelStat( extractedValueMap );
      if (count > 0) {
        success += 1;
      }
      System.out.println( "UPDATE COUNT: " + count );
    }

    EgovMap message = new EgovMap();
    message.put( "message", String.format("Total records processed: %d, Successful: %d, Failed: %d", total, success, fail) );

    return message;
  }

  @Override
  public EgovMap getStoSup(Map<String, Object> params) {
    return supplementUpdateMapper.getStoSup(params);
  }

  @Override
  public EgovMap SP_STO_PRE_SUPP(Map<String, Object> params) {
    return (EgovMap) supplementUpdateMapper.SP_STO_PRE_SUPP(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void sendEmail(Map<String, Object> params) {
    EmailVO email = new EmailVO();
    //String emailTitle = paymentApiMapper.getEmailTitle(params);
    //Map<String, Object> params = new HashMap<>();
    String emailTitle = "Track Your Parcel ["+params.get("inputParcelTrackNo")+"] : GDEX Delivery In Progress.";
    String content = "";

    LOGGER.info("############################ sendEmail - params: {}", params);

    /*Map<String, Object> additionalParams = (Map<String, Object>) paymentApiMapper.getEmailDetails(params);
    params.putAll(additionalParams);*/

 //   List<String> emailNo = new ArrayList<String>();

    List<String> emailNo = Arrays.asList("alex.lau@coway.com.my");

/* if (!"".equals(CommonUtils.nvl(params.get("email1")))) {
      emailNo.add(CommonUtils.nvl(params.get("email1")));
    }

    if (!"".equals(CommonUtils.nvl(params.get("email2")))) {
      emailNo.add(CommonUtils.nvl(params.get("email2")));
    }*/

/*    String text = "";
    text += "Dear All,\r\n\r\n";
    text += "Hereby is Hello World";
    text +=  "Sincere Regards,\r\n";
    text +=  "IT Department";*/


    if (params.get("emailType") == "1"){

    content+="<html>" +
            "<body>" +
            "<img src=\"cid:coway_header\" align=\"center\" style=\"display:block; margin: 0 auto; max-width: 100%; height: auto; padding: 20px 0;\"/><br/>" +
            "<h3>Your order is confirm!</h3>" +
            "Dear "+params.get("custName")+" ,<br/><br/>"+
          "Thank you for your purchase! Your order "+params.get("supRefNo")+" has successfully been placed.<br/>" +

            "Track your shipment here : "+params.get("inputParcelTrackNo")+" <br/><br/>" +
    		"https://gdexpress.com/tracking/<br/>" +
    		"Simply key in the tracking number to track your order.<br/><br/>" +
    		"<br/><br/>" +
    		"Best Regards, <br/>" +
    		"Coway <br/><br/>" ;

    } else if (params.get("emailType") == "2"){

    	content+="<html>" +
                "<body>" +
                "<img src=\"cid:coway_header\" align=\"center\" style=\"display:block; margin: 0 auto; max-width: 100%; height: auto; padding: 20px 0;\"/><br/>" +
                "<h3>Your package has been delivered!</h3>" +
                "Dear "+params.get("custName")+" ,<br/><br/>"+
                "Your order :"+params.get("supRefNo")+"<br/>" +

                "We hope you enjoy our products. Cheers to better health!<br/><br/>" +

        		"Best Regards, <br/>" +
        		"Coway <br/><br/>" +

				"Please do not reply to this email as this is a computer generated message.<br/>" ;
    }

    email.setText(content);

    params.put(REPORT_FILE_NAME, "/services/mibile_email_test.rpt");// visualcut
    params.put(EMAIL_SUBJECT, "Daily Accumulated Key-In Sales Analysis Report (HP)");
    params.put(EMAIL_TO, emailNo);
    params.put(EMAIL_TEXT, email);
                                                                                  // rpt
                                                                                  // file
                                                                                  // name.
    //params.put(REPORT_VIEW_TYPE, "PDF"); // viewType
    //params.put(REPORT_VIEW_TYPE, "MAIL_PDF"); // viewType
    //params.put("v_Param", " ");// parameter
    //params.put(AppConstants.REPORT_DOWN_FILE_NAME, "HelloWorld" + CommonUtils.getNowDate() + ".pdf");

/*    try {
		this.view(null, null, params);
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}*/

    LOGGER.info("[END] HelloWorld...");


    email.setTo(emailNo);
    //email.setHtml(false);
    email.setHtml(true);
    email.setSubject(emailTitle);
    email.setHasInlineImage(true);
    //email.setText(text);

    boolean isResult = false;

    isResult = adaptorService.sendEmailSupp(email, false);
  }

}