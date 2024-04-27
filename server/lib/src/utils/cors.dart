Map<String, Object> corsHeaders([int? port]) => {
      'Access-Control-Allow-Origin': "http://localhost:${port ?? 5173}",
      'Access-Control-Allow-Methods': ["GET", "POST"],
      'Access-Control-Allow-Headers': ["Content-Type", "Authorization"],
      'Access-Control-Allow-Credentials': "true"
    };
