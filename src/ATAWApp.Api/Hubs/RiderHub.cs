using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAWApp.Api.Hubs
{
    public class RiderHub : Hub
    {
        public async Task SendLocation(Guid riderId, double lat, double lng)
        {
            await Clients.All.SendAsync("ReceiveLocation", riderId, lat, lng);
        }
    }
}
