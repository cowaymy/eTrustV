<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<section class="pop_body"><!-- pop_body start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:145px" />
        <col style="width:*" />
        <col style="width:115px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Status</th>
        <td><span>${detailcontact.name}</span></td>
        <th scope="row">Create By</th>
        <td><span><c:if test="${not empty detailcontact.crtdt}">(${detailcontact.crtdt})</c:if></span></td>
    </tr>
    <tr>
        <th scope="row">Initial</th>
        <td><c:if test="${detailcontact.custinitial ne 0}">${detailcontact.custinitial}</c:if></td>
        <th scope="row">Update By</th>
        <td>${detailcontact.username1}<c:if test="${not empty detailcontact.upddt}">(${detailcontact.upddt})</c:if></td>
    </tr>
    <tr>
        <th scope="row">Name</th>
        <td>${detailcontact.name1}</td>
        <th scope="row">NRIC</th>
        <td>${detailcontact.nric}</td>
    </tr>
    <tr>
        <th scope="row">DOB</th>
        <td><c:if test="${detailcontact.dob ne '01-01-1900'}">${detailcontact.dob}</c:if></td>
        <th scope="row">Gender</th>
        <td>
            <c:if test="${detailcontact.gender eq 'F'}">
                Female
            </c:if>
            <c:if test="${detailcontact.gender eq 'M'}">
                Male
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row">Race</th>
        <td>${detailcontact.codename}</td>
        <th scope="row">Email</th>
        <td>${detailcontact.email}</td>
    </tr>
    <tr>
        <th scope="row">Tel (Mobile)</th>
        <td>${detailcontact.telm1}</td>
        <th scope="row">Tel (Office)</th>
        <td>${detailcontact.telo }</td>
    </tr>
    <tr>
        <th scope="row">Tel (Residence)</th>
        <td>${detailcontact.telr }</td>
        <th scope="row">Tel (Fax)</th>
        <td>${detailcontact.telf}</td>
    </tr>
    <tr>
        <th scope="row">Department</th>
        <td>${detailcontact.dept}</td>
        <th scope="row">Post</th>
        <td>${detailcontact.pos}</td>
    </tr>
    </tbody>
    </table><!-- table end -->

</section><!-- pop_body end -->