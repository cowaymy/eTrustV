package com.coway.trust.biz.api.vo;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.Date;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "HcSurveyResultCsvVO", description = "HcSurveyResultCsvVO")
public class HcSurveyResultCsvVO{
	private int txnId;
	private Date statisticsProcessed;
	private Date statisticsUnsubscribed;
	private Date statisticsSent;
	private Date statisticsDelivered;
	private Date statisticsSeen;
	private Date statisticsClicked;
	private Date statisticsResponded;
	private String response;

	public static HcSurveyResultCsvVO create(String[] CSVRecord) throws ParseException{
		HcSurveyResultCsvVO vo = new HcSurveyResultCsvVO();
		SimpleDateFormat dtFormat = new SimpleDateFormat("yyyyMMdd HH:mm:ss");

		vo.setTxnId(Integer.parseInt(CSVRecord[0]));
		vo.setStatisticsProcessed((CSVRecord.length < 2 || CSVRecord[1].isEmpty()) ? null : dtFormat.parse(CSVRecord[1]));
		vo.setStatisticsUnsubscribed((CSVRecord.length < 3 || CSVRecord[2].isEmpty()) ? null : dtFormat.parse(CSVRecord[2]));
		vo.setStatisticsSent((CSVRecord.length < 4 || CSVRecord[3].isEmpty()) ? null : dtFormat.parse(CSVRecord[3]));
		vo.setStatisticsDelivered((CSVRecord.length < 5 || CSVRecord[4].isEmpty()) ? null : dtFormat.parse(CSVRecord[4]));
		vo.setStatisticsSeen((CSVRecord.length < 6 || CSVRecord[5].isEmpty()) ? null : dtFormat.parse(CSVRecord[5]));
		vo.setStatisticsClicked((CSVRecord.length < 7 || CSVRecord[6].isEmpty()) ? null : dtFormat.parse(CSVRecord[6]));
		vo.setStatisticsResponded((CSVRecord.length < 8 || CSVRecord[7].isEmpty()) ? null : dtFormat.parse(CSVRecord[7]));
		vo.setResponse((CSVRecord.length < 9 || CSVRecord[8].isEmpty()) ? null : CSVRecord[8]);

		return vo;
	}

	public int getTxnId() {
		return txnId;
	}

	public void setTxnId(int txnId) {
		this.txnId = txnId;
	}

	public Date getStatisticsProcessed() {
		return statisticsProcessed;
	}

	public void setStatisticsProcessed(Date statisticsProcessed) {
		this.statisticsProcessed = statisticsProcessed;
	}

	public Date getStatisticsUnsubscribed() {
		return statisticsUnsubscribed;
	}

	public void setStatisticsUnsubscribed(Date statisticsUnsubscribed) {
		this.statisticsUnsubscribed = statisticsUnsubscribed;
	}

	public Date getStatisticsSent() {
		return statisticsSent;
	}

	public void setStatisticsSent(Date statisticsSent) {
		this.statisticsSent = statisticsSent;
	}

	public Date getStatisticsDelivered() {
		return statisticsDelivered;
	}

	public void setStatisticsDelivered(Date statisticsDelivered) {
		this.statisticsDelivered = statisticsDelivered;
	}

	public Date getStatisticsSeen() {
		return statisticsSeen;
	}

	public void setStatisticsSeen(Date statisticsSeen) {
		this.statisticsSeen = statisticsSeen;
	}

	public Date getStatisticsClicked() {
		return statisticsClicked;
	}

	public void setStatisticsClicked(Date statisticsClicked) {
		this.statisticsClicked = statisticsClicked;
	}


	public Date getStatisticsResponded() {
		return statisticsResponded;
	}

	public void setStatisticsResponded(Date statisticsResponded) {
		this.statisticsResponded = statisticsResponded;
	}

	public String getResponse() {
		return response;
	}

	public void setResponse(String response) {
		this.response = response;
	}
}
