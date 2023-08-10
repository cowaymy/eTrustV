<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>
	.height-style{
	    height:25px
	}
</style>
<section id="content">

    <ul class="path"></ul>
    <aside class="title_line">
        <p class="fav"><a></a><h2>HP Award History Report</h2></p>
        <ul class="right_btns">
            <li><p class="btn_blue" id="btnSearch"><a><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue" id="btnClear"><a><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside>

    <form id="hpAwardHistoryReportForm">
        <table class="type1">
            <colgroup>
                <col style="width: 150px;"/>
                <col style="width: *;"/>
                <col style="width: 150px;"/>
                <col style="width: *;"/>
            </colgroup>
            <tbody>
                <tr>
                    <th>Org Code</th>
                    <td><input class="w100p checkViewHistory" type="text" name="orgCode" id="orgCode"/>
                           <input type="hidden" name="memLvl" id="memLvl"/>
                    </td>

                    <th>Grp Code</th>
                    <td><input class="w100p checkViewHistory" type="text" name="grpCode" id="grpCode"/></td>

                    <th>Dept Code</th>
                    <td><input class="w100p checkViewHistory" type="text" name="deptCode" id="deptCode"/></td>

                     <th>Member Code</th>
                    <td><input class="w100p checkViewHistory" type="text" name="memCode"/></td>
                </tr>

                <tr>
                    <th>Incentive Type</th>
                    <td><select class="w100p checkViewHistory" multiple="multiple" name="incentiveType" id="incentiveType"></select></td>

                    <th>Year</th>
                    <td><select class="w100p checkViewHistory" name="year" id="year"></select></td>

                    <th>Month</th>
                    <td><select class="w100p checkViewHistory" multiple="multiple" name="month" id="month"></select></td>

                    <th></th>
                    <td></td>
                </tr>
            </tbody>
         </table>
      </form>

      <ul class="right_btns">
             <li><p class="btn_grid"><a href="#" onClick="downloadExcel()">Generate</a></p></li>
      </ul>
      <article class="grid_wrap">
             <div id="hpAwardHistoryReportGrid" style="width: 100%; height: 500px; margin: 0 auto;"></div>
      </article>
</section>


<script>
       const month = document.getElementById("month");
       const year = document.getElementById("year");
       const incentiveType = document.getElementById("incentiveType");
       $("#memLvl").val("${SESSION_INFO.memberLevel}");
       let reportType;

       const getMonth = () =>{
    	   month.innerHTML = "";
    	   fetch("/organization/selectMonthList.do")
    	   .then(r=>r.json())
    	   .then(data=>{
    	       for(let i = 0; i < data.length; i++) {
                   const {codeName, codeId} = data[i]
                   month.innerHTML += "<option value='" + codeId + "'>" + codeName + "</option>"
               }
    	       $(month).multipleSelect({
    	            selectAll : true,
    	            width : '80%'
    	        })
    	   })
       }

       const getYear = () =>{
    	   year.innerHTML = "";
    	   year.innerHTML += "<option value=''>Choose One</option>";
           fetch("/organization/selectYearList.do")
           .then(r=>r.json())
           .then(data=>{
               for(let i = 0; i < data.length; i++) {
                   const {codeName, codeId} = data[i]
                   year.innerHTML += "<option value='" + codeId + "'>" + codeName + "</option>"
               }
           })
       }

       const getIncentiveType = () =>{
    	   incentiveType.innerHTML = "";
           fetch("/organization/selectIncentiveCode.do")
           .then(r=>r.json())
           .then(data=>{
               for(let i = 0; i < data.length; i++) {
                   const {incentiveCode, incentiveDescription} = data[i]
                   incentiveType.innerHTML += "<option value='" + incentiveCode + "'>" + incentiveDescription + "</option>"
               }
               $(incentiveType).multipleSelect({
                    selectAll : true,
                    width : '80%'
                })
           })
       }

       getMonth();
       getYear();
       getIncentiveType();

       const hpAwardHistoryReportGrid =   GridCommon.createAUIGrid('hpAwardHistoryReportGrid',[
	   {
	          dataField : 'month', headerText : 'Month'
	   },
	   {
	          dataField : 'year', headerText : 'Year'
	   },
	   {
              dataField : 'memCode', headerText : 'Member Code'
       },
       {
              dataField : 'memName', headerText : 'Member Name', width: '20%'
       },
       {
              dataField : 'orgCode', headerText : 'Org Code'
       },
       {
              dataField : 'grpCode', headerText : 'Grp Code'
       },
       {
              dataField : 'deptCode', headerText : 'Dept Code'
       },
	   {
	          dataField : 'description', headerText : 'Description'
	   },
	   {
	          dataField : 'destination', headerText : 'Destination'
	   },
	   {
              dataField : 'remark', headerText : 'Remark'
       }],'',
	   {
	          usePaging: true,
	          pageRowCount: 20,
	          editable: false,
	          showRowNumColumn: true,
	          wordWrap: true,
	          showStateColumn: false,
	          rowStyleFunction: (i, item) => { return "height-style";}
	   });

       const downloadExcel = () => {
    	    GridCommon.exportTo("hpAwardHistoryReportGrid", "xlsx", "HP - Award History_" + reportType + "_" + moment().format("YYYYMMDD"));
       }

       const setOrganizationInfo = () => {
           if("${orgCode}") $("#orgCode").val("${orgCode}".trim());
           if("${grpCode}") $("#grpCode").val("${grpCode}".trim());
           if("${deptCode}") $("#deptCode").val("${deptCode}".trim());

           switch("${SESSION_INFO.memberLevel}") {
           case "3":
               reportType = "HM";
               $("#orgCode").attr("class", "w100p readonly checkViewHistory");
               $("#orgCode").attr("readonly", "readonly");
               $("#grpCode").attr("class", "w100p readonly checkViewHistory");
               $("#grpCode").attr("readonly", "readonly");
               $("#deptCode").attr("class", "w100p readonly checkViewHistory");
               $("#deptCode").attr("readonly", "readonly");
               break;
           case "2":
               reportType = "SM";
               $("#orgCode").attr("class", "w100p readonly checkViewHistory");
               $("#orgCode").attr("readonly", "readonly");
               $("#grpCode").attr("class", "w100p readonly checkViewHistory");
               $("#grpCode").attr("readonly", "readonly");
               break;
           case "1":
               reportType = "GM";
               $("#orgCode").attr("class", "w100p readonly checkViewHistory");
               $("#orgCode").attr("readonly", "readonly");
               break;
           default:
               reportType = "SGM";
               break;
             }
       }

       setOrganizationInfo();

       $("#btnSearch").click((e)=>{
           e.preventDefault();

           let check = [...document.querySelectorAll(".checkViewHistory")].some(r=>
           {
               if(r.value?.trim()){
                   return true;
                }
           });

           if(check){
               Common.showLoader();
               fetch("/organization/selectHpAwardHistoryReport.do?" + $("#hpAwardHistoryReportForm").serialize())
               .then(r=>r.json())
               .then(data => {
                   Common.removeLoader();
                   AUIGrid.setGridData(hpAwardHistoryReportGrid, data);
               });
           }else{
               Common.alert("Please fill in one of searching criteria.")
           }
       });

       $("#btnClear").click((e)=>{
           e.preventDefault();
           document.getElementById("hpAwardHistoryReportForm").reset();
           setOrganizationInfo();
       });

</script>