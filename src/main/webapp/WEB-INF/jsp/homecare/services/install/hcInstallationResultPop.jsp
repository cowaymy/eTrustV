<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
var myGridID3;
var installAccTypeId = 603;
var installAccValues = JSON.parse("${installAccValues}");

//Start AUIGrid
$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid3();
    fn_installationResult();

    fn_setResultCheck();


});


    function fn_setResultCheck(){
	    if("${resultInfo.allowComm}" =="1"){
	            $("#allowCheck").attr("checked",true);
	    }
	    if("${resultInfo.isTradeIn}" =="1"){
	            $("#tradeCheck").attr("checked",true);
	    }
	    if("${resultInfo.requireSms}" =="1"){
	            $("#smsCheck").attr("checked",true);
	    }
	    if ("${resultInfo.dismantle}" == 1) {
	        $('input:radio[name=dismantle][value="1"]').attr('checked', true);
	      }else{
	          $('input:radio[name=dismantle][value="0"]').attr('checked', true);
	      }
	    if(installAccValues != null){
    		$("#chkInstallAcc").attr("checked",true);
    		doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
    	}
    }


function createAUIGrid3() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "installEntryId",
        headerText : "Type",
        editable : false,
        width : 120
    }, {
        dataField : "installEntryNo",
        headerText : "Install No.",
        editable : false,
        width : 130
    }, {
        dataField : "installDt",
        headerText : "Date",
        editable : false,
        width : 130,
        dataType : "date", formatString : "dd/mm/yyyy"
    }, {
        dataField : "code",
        headerText : "Status",
        editable : false,
        width : 130,
        visible:false
    }, {
        dataField : "memCode",
        headerText : "DT Code",
        editable : false,
        width : 180
    }, {
        dataField : "userName",
        headerText : "Key By",
        editable : false,
        width : 180
    }, {
        dataField : "c2",
        headerText : "Key At",
        editable : false,
        width : 180,
        dataType : "date", formatString : "dd/mm/yyyy"
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID3 = AUIGrid.create("#grid_wrap3", columnLayout, gridPros);

}







function fn_installationResult(){
    var jsonObj = {
            resultId : $("#resultId").val()
       };

    Common.ajax("GET", "/services/viewInstallationResult.do",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID3, result);
    });

}

function f_multiCombo(){
    $(function() {
        $('#installAcc').change(function() {
        }).multipleSelect({
            selectAll: false, // 전체선택
            width: '80%'
        }).multipleSelect("setSelects", installAccValues);
    });
}

function fn_InstallAcc_CheckedChanged(_obj) {
    if (_obj.checked) {
        doGetComboSepa('/common/selectCodeList.do', installAccTypeId, '', '','installAcc', 'M' , 'f_multiCombo');
    } else {
        doGetComboSepa('/common/selectCodeList.do', 0, '', '','installAcc', 'M' , 'f_multiCombo');
    }
  }





function fn_winClose(){

    this.close();
}
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Installation Result</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#none">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="grid_wrap3" style="width: 100%; height: 130px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<form action="#" id="membeSponForm" method="post">
 <input type="hidden" value="<c:out value="${resultInfo.resultId}"/>" id="resultId"/>
 <input type="hidden" value="<c:out value="${resultInfo.allowComm}"/>" id="resultId"/>
 <input type="hidden" value="<c:out value="${resultInfo.isTradeIn}"/>" id="resultId"/>
 <input type="hidden" value="<c:out value="${resultInfo.requireSms}"/>" id="resultId"/>

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Install No</th>
    <td>
     <span><c:out value="${resultInfo.installEntryNo}"/></span>
    </td>
    <th scope="row">Status</th>
    <td>
    <span><c:out value="${resultInfo.name}"/></span>
    </td>
</tr>
<tr>
    <th scope="row" style="width: 103px; ">Install Date</th>
    <td style="width: 129px; ">
    <span><c:out value="${resultInfo.installDt}"/></span>
    </td>
    <th scope="row" style="width: 117px; ">Technician</th>
    <td style="width: 173px; ">
    <span><c:out value="${resultInfo.c1}"/></span>
    </td>

</tr>
<tr>
    <th scope="row">SIRIM No.</th>
    <td>
    <span><c:out value="${resultInfo.sirimNo}"/></span>
    </td>
    <th scope="row">Serial No.</th>
    <td>
    <span><c:out value="${resultInfo.serialNo}"/></span>
    </td>
</tr>
<tr>
  <th scope="row">Dismantle<span  class="must airconm" style="display:none">*</span></th>
   <td colspan="1">
        <label><input type="radio" name="dismantle" disabled="disabled" value="1"/><span>Yes</span></label>
        <label><input type="radio" name="dismantle" disabled="disabled" value="0"/><span>No</span></label>
</td>
   <th scope="row"></th><td></td>
 </tr>
 <tr>
   <th scope="row">Total Copper Pipe<span  class="must airconm" style="display:none">*</span></th>
  <td>
  <span><c:out value="${resultInfo.totPipe}"/></span>
    <span>ft</span>
  </td>
  <th scope="row" rowspan="2">Gas Pressue <span  class="must airconm"  style="display:none">*</span><br/>Before Installation<br/>After Installation
  </th>

  <td rowspan="1">
  <span ><c:out value="${resultInfo.gasPresBef}"/>  PSI</span>
  </td>
</tr>
<tr>
  <th scope="row">Total Wire<span  class="must airconm" style="display:none">*</span></th>
  <td>
  <span><c:out value="${resultInfo.totWire}"/></span>
    <span>ft</span>
  </td>
  <td rowspan="1">
    <span><c:out value="${resultInfo.gasPresAft}"/>  PSI</span>
  </td>
</tr>
<tr>
    <th scope="row" colspan="4">
    <span><input type="checkbox" disabled="disabled" id="allowCheck"/>Allow Commission ?</span>
    <span><input type="checkbox" disabled="disabled" id="tradeCheck"/>Product Trade In ?</span>
    <span><input type="checkbox" disabled="disabled" id="smsCheck"/>Required SMS ?</span>
    </th>

</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3">
        <span><c:out value="${resultInfo.rem}"/></span>
    </td>
</tr>
<tr>
           <th scope="row"><spring:message code="service.title.installation.accessories" />
          <input type="checkbox" id="chkInstallAcc" name="chkInstallAcc" onChange="fn_InstallAcc_CheckedChanged(this)"/></th>
    		<td colspan="3">
    		<select class="w100p" id="installAcc" name="installAcc">
    		</select>
    		</td>
          </tr>
<tr>
<tr>
    <th scope="row">Result Key By</th>
    <td>
    <span><c:out value="${resultInfo.memCode}"/></span>
    </td>
    <th scope="row">Result Key At</th>
    <td>
    <span><c:out value="${resultInfo.c2}"/></span>
    </td>
</tr>
</tbody>
</table>

</form>
</section><!-- search_table end -->

<ul class="center_btns">
</ul>

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
