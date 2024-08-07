package com.coway.trust.biz.eAccounting.creditCard.impl;

import java.text.ParseException;
import java.util.Date;
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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.eAccounting.creditCard.CreditCardAllowancePlanService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("creditCardAllowancePlanService")
public class CreditCardAllowancePlanServiceImpl  implements CreditCardAllowancePlanService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CreditCardAllowancePlanServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "creditCardAllowancePlanMapper")
	private CreditCardAllowancePlanMapper creditCardAllowancePlanMapper;

	@Autowired
	private WebInvoiceMapper webInvoiceMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> getCreditCardHolderList(Map<String, Object> params) {
		return creditCardAllowancePlanMapper.getCreditCardHolderList(params);
	}

	@Override
	public EgovMap getCreditCardHolderDetail(Map<String, Object> params) {
		return creditCardAllowancePlanMapper.getCreditCardHolderDetail(params);
	}

	@Override
	public List<EgovMap> getAllowanceLimitDetailPlanList(Map<String, Object> params) {
		return creditCardAllowancePlanMapper.getAllowanceLimitDetailPlanList(params);
	}

	@Override
	public EgovMap getAllowanceLimitDetailPlan(Map<String, Object> params) {
		return creditCardAllowancePlanMapper.getAllowanceLimitDetailPlan(params);
	}

	@Override
	public void updateAllowancePlanList(Map<String, Object> params) {
		// TODO Auto-generated method stub
	}

	@Override
	public ReturnMessage createAllowanceDetailLimitPlan(Map<String, Object> params, SessionVO sessionVO) {
	    SimpleDateFormat dateStringFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	    SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yyyy");
		params.put("startDate", "01/" + params.get("startDate").toString());
		params.put("endDate", dateStringFormat.format(endMonthFormatter("01/" + params.get("endDate").toString())));


		params.put("createdBy", sessionVO.getUserId());
		params.put("updatedBy", sessionVO.getUserId());
		//Active = 1, Inactive = 8
		// TODO Auto-generated method stub
        ReturnMessage message = new ReturnMessage();
		String startDate = params.get("startDate").toString();
		String endDate = params.get("endDate").toString();
		Date startDateFormat;
		Date endDateFormat;
		Date currentDateFormat;
		try {
			Calendar currentDate = Calendar.getInstance();
			currentDate.set(Calendar.DAY_OF_MONTH, 1);
			currentDateFormat =  dateFormatter.parse(dateFormatter.format(currentDate.getTime()));
			startDateFormat = dateFormatter.parse(startDate);
			//Format End Date to {date 23:59:59}
			endDateFormat = endDateFormatter(endDate,0);

			//Current Date is Later than Start Date
			if(currentDateFormat.compareTo(startDateFormat) > 0){
		        message.setCode(AppConstants.FAIL);
				message.setMessage("Current Month is later than Start Month");
				return message;
			}

			//Check if start date lies on existing start date, if yes then reject creation
			List<EgovMap> checkIfAllowanceLimitDetailStartDateExist = creditCardAllowancePlanMapper.checkIfAllowanceLimitDetailStartDateExist(params);

			if(checkIfAllowanceLimitDetailStartDateExist.size() > 0){
		        message.setCode(AppConstants.FAIL);
				message.setMessage("Similar start date exist in current user record. Please try other dates");
				return message;
			}

			// Get if start date lies in between a valid detail record
			List<EgovMap> checkInBetweenAllowanceDetailExist = creditCardAllowancePlanMapper.checkInBetweenAllowanceLimitDetailExist(params);
			// Get upcoming start date record if exist
			List<EgovMap> checkUpcomingAllowanceDetailExist = creditCardAllowancePlanMapper.checkUpcomingAllowanceLimitDetailExist(params);

			if(checkInBetweenAllowanceDetailExist.size() > 0){
				if(checkUpcomingAllowanceDetailExist.size() > 0){
					//Edit current valid record end date to nearest upcoming start date
					EgovMap upcomingAllowanceDetail = checkUpcomingAllowanceDetailExist.get(0);

					//check if new record end date falls in between upcoming allowance detail(return fail)
					Date upcomingStartDate = dateFormatter.parse(upcomingAllowanceDetail.get("startDate").toString());
					if(endDateFormat.compareTo(upcomingStartDate) > 0){
						message.setCode(AppConstants.FAIL);
						message.setMessage("Current End Date has conflict with Upcoming Start Date. Please try again");
						return message;
					}

					params.put("endDate", dateStringFormat.format(endDateFormatter(upcomingAllowanceDetail.get("startDate").toString(),-1)));
				}
				else{
					//Means no upcoming record, so we set the end date to 01/01/9999 to ensure that this will valid as long as possible
					params.put("endDate",dateStringFormat.format(endDateFormatter("01/01/9999",0)));
				}

				//Edit existing record end date to -1 day of start date of new record
				//set end date of new record insert to 01/01/9999
				EgovMap existingAllowanceDetail = checkInBetweenAllowanceDetailExist.get(0);
				existingAllowanceDetail.put("endDate", dateStringFormat.format(endDateFormatter(startDate,-1)));
				creditCardAllowancePlanMapper.updateAllowanceLimitDetail(existingAllowanceDetail);
			}
			else{
				if(checkUpcomingAllowanceDetailExist.size() > 0){
					//Edit current valid record end date to nearest upcoming start date
					EgovMap upcomingAllowanceDetail = checkUpcomingAllowanceDetailExist.get(0);

					//check if new record end date falls in between upcoming allowance detail(return fail)
					Date upcomingStartDate = dateFormatter.parse(upcomingAllowanceDetail.get("startDate").toString());
					if(endDateFormat.compareTo(upcomingStartDate) > 0){
						message.setCode(AppConstants.FAIL);
						message.setMessage("Current End Date has conflict with Upcoming Start Date. Please try again");
						return message;
					}

					params.put("endDate", dateStringFormat.format(endDateFormatter(upcomingAllowanceDetail.get("startDate").toString(),-1)));
				}
				else{
					//Means no upcoming record, so we set the end date to 01/01/9999 to ensure that this will valid as long as possible
					params.put("endDate",dateStringFormat.format(endDateFormatter("01/01/9999",0)));
				}
			}

			int result = creditCardAllowancePlanMapper.insertAllowanceLimitDetail(params);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			message.setMessage("Unexpected Date Error");
			return message;
		}
        message.setCode(AppConstants.SUCCESS);
		return message;
	}

	@Override
	public ReturnMessage removeAllowanceLimitDetailPlan(Map<String, Object> params, SessionVO sessionVO) {
	    SimpleDateFormat dateStringFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		params.put("updatedBy", sessionVO.getUserId());
        ReturnMessage message = new ReturnMessage();
        //Before remove, have to check if current record is in between previous or next record
        EgovMap allowancePlanDetailToBeRemove = creditCardAllowancePlanMapper.getAllowanceLimitDetailPlan(params);

        params.put("startDate", allowancePlanDetailToBeRemove.get("startDate").toString());
        EgovMap allowancePlanDetailBefore = creditCardAllowancePlanMapper.getAllowanceLimitDetailPlanBefore(params);
        EgovMap allowancePlanDetailAfter = creditCardAllowancePlanMapper.getAllowanceLimitDetailPlanAfter(params);

        if(allowancePlanDetailBefore == null){
//        	message.setCode(AppConstants.FAIL);
//			message.setMessage("There are no previous limit plan before this, unable to remove");
//			return message;
        }
        else {
        	//allowancePlanDetailBefore not null, then allowancePlanDetailBefore end date have to change to be start date -1 of allowancePlanDetailAfter
        	if(allowancePlanDetailAfter != null) {
        		allowancePlanDetailBefore.put("endDate", dateStringFormat.format(endDateFormatter(allowancePlanDetailAfter.get("startDate").toString(),-1)));
        	}
        	else{
        		allowancePlanDetailBefore.put("endDate", dateStringFormat.format(endDateFormatter("01/01/9999",0)));
        	}
			creditCardAllowancePlanMapper.updateAllowanceLimitDetail(allowancePlanDetailBefore);
        }

		int result = creditCardAllowancePlanMapper.removeAllowanceLimitDetail(params);

		if(result > 0){
	        message.setCode(AppConstants.SUCCESS);
		}
		else{
	        message.setCode(AppConstants.FAIL);
			message.setMessage("Unexpected Date Error");
		}

		return message;
	}


	@Override
	public ReturnMessage editAllowanceLimitDetailPlan(Map<String, Object> params, SessionVO sessionVO) {
        ReturnMessage message = new ReturnMessage();
		params.put("updatedBy", sessionVO.getUserId());
		int result = creditCardAllowancePlanMapper.updateAllowanceLimitDetailAmount(params);

		if(result > 0){
	        message.setCode(AppConstants.SUCCESS);
		}
		else{
	        message.setCode(AppConstants.FAIL);
			message.setMessage("Unexpected Update Error");
		}

		return message;
	}

	public Date endMonthFormatter(String endDate){
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		Calendar endDateAdjustment = Calendar.getInstance();
		try {
			Date parseDate = dateFormat.parse(endDate);
			endDateAdjustment.setTime(parseDate);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		endDateAdjustment.add(Calendar.MONTH, 1);
		endDateAdjustment.add(Calendar.DATE, -1);

		return endDateAdjustment.getTime();
	}

	public Date endDateFormatter(String endDate, int dayAdjustment){
	    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		Calendar endDateAdjustment = Calendar.getInstance();
		try {
			Date parseDate = dateFormat.parse(endDate);
			endDateAdjustment.setTime(parseDate);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		endDateAdjustment.set(Calendar.HOUR_OF_DAY, 23);
		endDateAdjustment.set(Calendar.MINUTE, 59);
		endDateAdjustment.set(Calendar.SECOND, 59);
		endDateAdjustment.set(Calendar.MILLISECOND, 999);

		if(dayAdjustment != 0){
			endDateAdjustment.add(Calendar.DATE, dayAdjustment);
		}

		return endDateAdjustment.getTime();
	}
}
