package com.coway.trust.biz.api.vo;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.Date;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "HcSurveyResultCsvVO", description = "HcSurveyResultCsvVO")
public class HcSurveyResultCsvVO{
	private int txnId;
	private Date statisticsProcessed;
	private Date statisticsSent;
	private Date statisticsDelivered;
	private Date statisticsSeen;
	private Date statisticsClicked;
	private Date statisticsViewed;
	private Date statisticsResponded;
	private String response;

	public static HcSurveyResultCsvVO create(String[] CSVRecord) throws ParseException{
		HcSurveyResultCsvVO vo = new HcSurveyResultCsvVO();
		SimpleDateFormat dtFormat = new SimpleDateFormat("yyyymmDD HH:mm:ss");

		vo.setTxnId(Integer.parseInt(CSVRecord[0]));
		vo.setStatisticsProcessed(CSVRecord[1].isEmpty() ? null : dtFormat.parse(CSVRecord[1]));
		vo.setStatisticsSent(CSVRecord[2].isEmpty() ? null : dtFormat.parse(CSVRecord[2]));
		vo.setStatisticsDelivered(CSVRecord[3].isEmpty() ? null : dtFormat.parse(CSVRecord[3]));
		vo.setStatisticsSeen(CSVRecord[4].isEmpty() ? null : dtFormat.parse(CSVRecord[4]));
		vo.setStatisticsClicked(CSVRecord[5].isEmpty() ? null : dtFormat.parse(CSVRecord[5]));
		vo.setStatisticsViewed(CSVRecord[6].isEmpty() ? null : dtFormat.parse(CSVRecord[6]));
		vo.setStatisticsResponded(CSVRecord[7].isEmpty() ? null : dtFormat.parse(CSVRecord[7]));
		vo.setResponse(CSVRecord[8]);

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

	public Date getStatisticsViewed() {
		return statisticsViewed;
	}

	public void setStatisticsViewed(Date statisticsViewed) {
		this.statisticsViewed = statisticsViewed;
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
